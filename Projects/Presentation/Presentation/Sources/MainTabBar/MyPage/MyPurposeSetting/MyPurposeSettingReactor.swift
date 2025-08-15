//
//  MyPurposeSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//


import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyPurposeSettingReactor: Reactor {
  
  public enum Action {
    case initialize
    case selectPurpose(RunningPurpose)
    case save
  }
  
  public enum Mutation {
    case setPurpose(RunningPurpose)
    case setIsSaved(Bool)
  }
  
  public struct State {
    fileprivate(set) var purpose: RunningPurpose = .weightLoss
    fileprivate(set) var isSaved: Bool = false
  }
  
  public var initialState: State = State()
  
  private let userUseCase: UserUseCase
  private let onboardngUseCase: OnboardingUseCase
  
  init(userUseCase: UserUseCase, onboardngUseCase: OnboardingUseCase) {
    self.userUseCase = userUseCase
    self.onboardngUseCase = onboardngUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return fetchUserInfo()
    case let .selectPurpose(item):
      return .just(.setPurpose(item))
    case .save:
      return savePurpose()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setPurpose(purpose):
      newState.purpose = purpose
      
    case let .setIsSaved(isSaved):
      newState.isSaved = isSaved
      
    }
    return newState
  }
  
  private func fetchUserInfo() -> Observable<Mutation> {
    return userUseCase
      .fetchMyUserInfo()
      .map { Mutation.setPurpose($0.goal.runningPurpose) }
      .asObservable()
  }
  
  private func savePurpose() -> Observable<Mutation> {
    return onboardngUseCase
      .savePurpose(currentState.purpose.rawValue)
      .map { _ in Mutation.setIsSaved(true) }
      .asObservable()
  }
}
