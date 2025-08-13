//
//  FirstRunningGoalSettingReactor.swift
//  Presentation
//
//  Created by dong eun shin on 8/1/25.
//

import ReactorKit
import Foundation
import Domain

final class FirstRunningGoalSettingReactor: Reactor {
  // MARK: - Reactor Definition

  enum Action {
    case updateGoalValue(String)
    case setAndRunButtonTapped
    case backButtonTapped
    case skipButtonTapped
    case viewDidAppear
    case animationDidFinish
  }

  enum Mutation {
    case setGoalValue(Int)
    case setLoading(Bool)
    case setAnimationPlaying(Bool)
    case setSaveSuccess(Bool)
    case setSaveError(Error?)
    case setNavigation(NavigationTarget?)
  }

  struct State {
    var inputType: GoalInputType
    var goalValue: Int // km
    var isLoading: Bool = false
    var isAnimationPlaying: Bool = false
    var saveSuccess: Bool?
    var saveError: Error?
    @Pulse var navigationTarget: NavigationTarget?
  }

  enum NavigationTarget: Equatable {
    case pop
    case showRunning
  }

  // MARK: - Properties

  let initialState: State
  private let disposeBag = DisposeBag()
  private let goalUseCase: GoalUseCase

  // MARK: - Initialization

  init(goalUseCase: GoalUseCase, inputType: GoalInputType) {
    self.goalUseCase = goalUseCase
    self.initialState = State(
      inputType: inputType,
      goalValue: inputType.initialGoalValue
    )
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateGoalValue(let text):
      let value = Int(text) ?? 0
      return .just(.setGoalValue(value))

    case .setAndRunButtonTapped:
      let currentGoal = currentState.goalValue
      let currentType = currentState.inputType

      let saveOperation: Single<Bool>
      switch currentType {
      case .time:
        saveOperation = goalUseCase.saveGoalTime(time: currentGoal)
      case .distance:
        saveOperation = goalUseCase.saveGoalDistance(distance: currentGoal)
      }

      return Observable.concat([
        .just(Mutation.setLoading(true)),

        saveOperation
          .map { success -> Mutation in
            return .setSaveSuccess(success)
          }
          .catch { error in
            print("Error saving goal: \(error)")
            return .just(.setSaveError(error))
          }
          .asObservable()
          .flatMap { saveResultMutation -> Observable<Mutation> in
            return Observable.concat([
              .just(saveResultMutation),
              .just(Mutation.setLoading(false))
            ])
          }
      ])

    case .backButtonTapped:
      return .just(.setNavigation(.pop))

    case .skipButtonTapped:
      return .just(.setNavigation(.showRunning))

    case .viewDidAppear:
      return .empty()

    case .animationDidFinish:
      return Observable.concat([
        .just(Mutation.setAnimationPlaying(false)),
        .just(Mutation.setNavigation(.showRunning))
      ])
    }
  }

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setGoalValue(let value):
      newState.goalValue = value
      newState.saveSuccess = nil
      newState.saveError = nil
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .setAnimationPlaying(let isPlaying):
      newState.isAnimationPlaying = isPlaying
    case .setSaveSuccess(let success):
      newState.saveSuccess = success
      newState.saveError = nil
    case .setSaveError(let error):
      newState.saveError = error
      newState.saveSuccess = false
    case .setNavigation(let target):
      newState.navigationTarget = target
    }
    return newState
  }
}
