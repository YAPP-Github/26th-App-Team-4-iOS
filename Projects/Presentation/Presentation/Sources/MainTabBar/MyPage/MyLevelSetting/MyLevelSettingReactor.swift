//
//  MyLevelSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//


import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyLevelSettingReactor: Reactor {
  
  public enum Action {
    case initialize
    case selectLevel(RunnerType)
    case save
  }
  
  public enum Mutation {
    case setLevel(RunnerType)
    case setIsSaved(Bool)
  }
  
  public struct State {
    fileprivate(set) var level: RunnerType = .beginner
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
      
    case let .selectLevel(item):
      return .just(.setLevel(item))
      
    case .save:
      return saveRunnerType()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setLevel(level):
      newState.level = level
      
    case let .setIsSaved(isSaved):
      newState.isSaved = isSaved
    }
    return newState
  }
  
  private func fetchUserInfo() -> Observable<Mutation> {
    return userUseCase
      .fetchMyUserInfo()
      .map { Mutation.setLevel($0.runnerType) }
      .asObservable()
  }
  
  private func saveRunnerType() -> Observable<Mutation> {
    return userUseCase
      .saveRunnerType(runnerType: currentState.level)
      .map { _ in Mutation.setIsSaved(true) }
      .asObservable()
  }
}
