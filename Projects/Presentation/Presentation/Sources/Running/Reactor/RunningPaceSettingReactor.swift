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

  // TODO: - 서버로 부터 값 받도록 수정
  private let challengerPace: Float = 5 * 60
  private let routinePace: Float = 7 * 60
  private let warmUpPace: Float = 9 * 60

  private lazy var paceValues: [Float] = [warmUpPace, routinePace, challengerPace]

  // MARK: - Reactor Definition

  enum Action {
    case sliderValueDidChange(Int)
    case paceInputDidChange(String)
    case confirmButtonTapped
    case backButtonTapped
    case closeInfoBanner
    case didFinishAnimation
  }

  enum Mutation {
    case setCurrentPace(Float)
    case setCurrentPaceIndex(Int)
    case setInfoBannerVisible(Bool)
    case setLoading(Bool)
    case setSaveSuccess(Bool?)
    case setSaveError(Error?)
    case setDidFinishAnimation(Bool)
  }

  struct State {
    var currentPace: Float
    var currentPaceIndex: Int
    var isInfoBannerVisible: Bool
    var isLoading: Bool
    var isSaveSuccess: Bool?
    var saveError: Error?
    var didFinishAnimation: Bool
  }

  let initialState: State
  private let paceUseCase: GoalUseCase

  // MARK: - Initialization

  init(paceUseCase: GoalUseCase) {
    self.paceUseCase = paceUseCase
    self.initialState = State(
      currentPace: 7 * 60,
      currentPaceIndex: 1,
      isInfoBannerVisible: true,
      isLoading: false,
      isSaveSuccess: nil,
      saveError: nil,
      didFinishAnimation: false
    )
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .sliderValueDidChange(let index):
      let clampedIndex = max(0, min(paceValues.count - 1, index))
      let pace = paceValues[clampedIndex]
      return .concat([
        .just(.setCurrentPace(pace)),
        .just(.setCurrentPaceIndex(clampedIndex))
      ])

    case .paceInputDidChange(let text):
      guard let pace = parsePace(text: text) else { return .empty() }
      let index = closestIndex(for: pace)
      return .concat([
        .just(.setCurrentPace(pace)),
        .just(.setCurrentPaceIndex(index))
      ])

    case .confirmButtonTapped:
      let pace = currentState.currentPace
      return Observable.concat([
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

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
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
    }
    return newState
  }

  // MARK: - Helpers

  private func parsePace(text: String) -> Float? {
    let cleanedDigits = text.filter(\.isWholeNumber)
    guard cleanedDigits.count >= 3 else { return nil }

    let minutesString = cleanedDigits.count == 4 ? cleanedDigits.prefix(2) : cleanedDigits.prefix(1)
    let minutes = Float(minutesString) ?? 0
    let secondsString = cleanedDigits.suffix(2)
    let seconds = Float(secondsString) ?? 0

    guard seconds < 60 else { return nil }

    return minutes * 60 + seconds
  }

  private func closestIndex(for pace: Float) -> Int {
    var closestIndex = 0
    var minDifference = Float.greatestFiniteMagnitude

    for (index, targetPace) in paceValues.enumerated() {
      let difference = abs(pace - targetPace)
      if difference < minDifference {
        minDifference = difference
        closestIndex = index
      }
    }
    return closestIndex
  }
}
