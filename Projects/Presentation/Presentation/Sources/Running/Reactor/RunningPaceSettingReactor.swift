//
//  RunningPaceSettingReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/21/25.
//

import ReactorKit
import Foundation
import Domain

final class RunningPaceSettingReactor: Reactor {
  
  // MARK: - Properties
  
  enum Action {
    case viewDidLoad
    case sliderValueDidChange(Int)
    case paceInputDidBeginEditing
    case paceInputDidEndEditing(String)
    case confirmButtonTapped
    case backButtonTapped
    case closeInfoBanner
    case didFinishAnimation
  }
  
  enum Mutation {
    case setPaceValues([Float])
    case setCurrentPace(Float)
    case setCurrentPaceIndex(Int)
    case setInfoBannerVisible(Bool)
    case setLoading(Bool)
    case setSaveSuccess(Bool?)
    case setSaveError(Error?)
    case setDidFinishAnimation(Bool)
    case showToast(String?)
    case setUnderlineVisible(Bool)
  }
  
  struct State {
    var paceValues: [Float] = []
    var currentPace: Float = 0
    var currentPaceIndex: Int = 0
    var isInfoBannerVisible: Bool = true
    var isLoading: Bool = false
    var isSaveSuccess: Bool?
    var saveError: Error?
    var didFinishAnimation: Bool = false
    var toastMessage: String?
    var shouldAnimateUnderline: Bool = false
  }
  
  let initialState: State
  private let paceUseCase: GoalUseCase
  
  init(paceUseCase: GoalUseCase) {
    self.paceUseCase = paceUseCase
    self.initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.setLoading(true)),
        paceUseCase.getRecommendPace()
          .asObservable()
          .flatMap { recommend -> Observable<Mutation> in
            let recommendSec = Float(recommend.recommendPace) / 1000.0
            let warmUpSec = recommendSec + 120
            let challengeSec = max(recommendSec - 120, 0)
            
            let values: [Float] = [warmUpSec, recommendSec, challengeSec]

            return .concat([
              .just(.setPaceValues(values)),
              .just(.setCurrentPace(recommendSec)),
              .just(.setCurrentPaceIndex(1))
            ])
          }
          .catch { _ in
            let fallback: [Float] = [540, 420, 300] // 9, 7, 5분
            return .concat([
              .just(.setPaceValues(fallback)),
              .just(.setCurrentPace(420)),
              .just(.setCurrentPaceIndex(1))
            ])
          },
        .just(.setLoading(false))
      ])
      
    case .sliderValueDidChange(let index):
      let values = currentState.paceValues
      guard !values.isEmpty, index >= 0, index < values.count else { return .empty() }
      let pace = values[index]
      
      let toastMessage = self.getToastMessage(for: index)
      
      return .concat([
        .just(.setCurrentPace(pace)),
        .just(.setCurrentPaceIndex(index)),
        .just(.showToast(toastMessage))
      ])
      
    case .paceInputDidBeginEditing:
      return .just(.setUnderlineVisible(true))
      
    case .paceInputDidEndEditing(let text):
      guard let pace = parsePace(text: text) else {
        return .empty()
      }
      
      let index = closestIndex(for: pace)
      let toastMessage = getToastMessage(for: index)
      
      return .concat([
        .just(.setCurrentPace(pace)),
        .just(.setCurrentPaceIndex(index)),
        .just(.showToast(toastMessage)),
        .just(.setUnderlineVisible(false))
      ])
      
    case .confirmButtonTapped:
      let pace = currentState.currentPace
      return .concat([
        .just(.setLoading(true)),
        paceUseCase.savePace(second: Int(pace))
          .map { success -> Mutation in
            return .setSaveSuccess(success)
          }
          .catch { error in
            return .just(.setSaveError(error))
          }
          .asObservable(),
        .just(.setLoading(false))
      ])
      
    case .backButtonTapped:
      return .empty()
      
    case .closeInfoBanner:
      return .just(.setInfoBannerVisible(false))
      
    case .didFinishAnimation:
      return .just(.setDidFinishAnimation(true))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setPaceValues(let values):
      newState.paceValues = values
    case .setCurrentPace(let pace):
      newState.currentPace = pace
    case .setCurrentPaceIndex(let index):
      newState.currentPaceIndex = index
    case .setInfoBannerVisible(let isVisible):
      newState.isInfoBannerVisible = isVisible
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .setSaveSuccess(let success):
      newState.isSaveSuccess = success
      newState.saveError = nil
    case .setSaveError(let error):
      newState.saveError = error
      newState.isSaveSuccess = false
    case .setDidFinishAnimation(let didFinish):
      newState.didFinishAnimation = didFinish
    case .showToast(let message):
      newState.toastMessage = message
    case .setUnderlineVisible(let isVisible):
      newState.shouldAnimateUnderline = isVisible
    }
    return newState
  }
    
  private func getToastMessage(for index: Int) -> String? {
    switch index {
    case 0:
      return "나에게 살짝 여유로운 페이스일 수 있어요."
    case 1:
      return "나에게 적절한 페이스에요."
    case 2:
      return "아직은 조금 벅찰 수 있는 페이스일 수 있어요."
    default:
      return nil
    }
  }
  
  public func parsePace(text: String) -> Float? {
    let cleanedDigits = text.filter(\.isWholeNumber)
    guard cleanedDigits.count >= 3 else { return nil }
    
    let minutesString = cleanedDigits.count == 4 ? cleanedDigits.prefix(2) : cleanedDigits.prefix(1)
    let minutes = Float(minutesString) ?? 0
    let secondsString = cleanedDigits.suffix(2)
    let seconds = Float(secondsString) ?? 0
    
    guard seconds < 60 else { return nil }
    return minutes * 60 + seconds
  }
  
  private func formatPace(seconds: Float) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%d'%02d''", minutes, remainingSeconds)
  }
  
  private func closestIndex(for pace: Float) -> Int {
    guard !currentState.paceValues.isEmpty else { return 0 }
    var closestIndex = 0
    var minDifference = Float.greatestFiniteMagnitude
    for (index, targetPace) in currentState.paceValues.enumerated() {
      let difference = abs(pace - targetPace)
      if difference < minDifference {
        minDifference = difference
        closestIndex = index
      }
    }
    return closestIndex
  }
}
