//
//  FirstRunningGoalSettingReactor.swift
//  Presentation
//
//  Created by dong eun shin on 8/1/25.
//

import ReactorKit
import Foundation
import Domain

public final class FirstRunningGoalSettingReactor: Reactor {

  // MARK: - Action
  public enum Action {
    case saveGoalTime(time: Int)
  }

  // MARK: - Mutation
  public enum Mutation {
    case setIsSaved(Bool)
  }

  // MARK: - State
  public struct State {
    @Pulse public fileprivate(set) var isSaved: Bool = false
  }

  public let initialState: State = State()
  private let goalUseCase: GoalUseCase

  public init(goalUseCase: GoalUseCase) {
    self.goalUseCase = goalUseCase
  }
}

private extension FirstRunningGoalSettingReactor {
  func saveGoalTime(time: Int) -> Observable<Mutation> {
    return goalUseCase.saveGoalTime(time: time)
      .map { _ in Mutation.setIsSaved(true) }
      .catch { _ in .just(.setIsSaved(false)) }
      .asObservable()
  }

  func saveGoalDistance(distance: Int) -> Observable<Mutation> {
    return goalUseCase.saveGoalDistance(distance: distance)
      .map { _ in Mutation.setIsSaved(true) }
      .catch { _ in .just(.setIsSaved(false)) }
      .asObservable()
  }
}

//
//final class FirstRunningGoalSettingReactor: Reactor {
//  // MARK: - Reactor Definition
//
//  // Action: User inputs and lifecycle events
//  enum Action {
//    case updateGoalValue(String)
//    case setAndRunButtonTapped
//    case backButtonTapped
//    case skipButtonTapped
//    case animationDidFinish
//    case viewDidAppear // To trigger initial focus
//  }
//
//  // Mutation: State changes caused by actions
//  enum Mutation {
//    case setGoalValue(Int)
//    case setLoading(Bool)
//    case setSaveSuccess(Bool)
//    case setSaveError(Error?) // Added for explicit error handling
//    case setNavigation(NavigationTarget?)
//  }
//
//  // State: Current state of the view controller
//  struct State {
//    var inputType: GoalInputType?
//    var goalValue: Int?
//    var isLoading: Bool?
//    var saveSuccess: Bool? // Nil until an attempt is made
//    var saveError: Error? // New: Stores any error from saving
//    @Pulse var navigationTarget: NavigationTarget? // Use @Pulse for one-time events
//  }
//
//  // NavigationTarget: Defines where the coordinator should navigate
//  enum NavigationTarget {
//    case pop
//    case showRunning // Modified: Removed associated values
//  }
//
//  // MARK: - Properties
//
//  let initialState: State = State()
//  private let goalUseCase: GoalUseCase
//
//  // MARK: - Initialization
//
//  init(goalUseCase: GoalUseCase) { // Accept GoalUseCase
//    self.goalUseCase = goalUseCase
//  }
//
//  // MARK: - Mutate (Business Logic)
//
//  func mutate(action: Action) -> Observable<Mutation> {
//    switch action {
//    case .updateGoalValue(let text):
//      // Convert text to Int, handle empty string or invalid input
//      let value = Int(text) ?? 0
//      return .just(.setGoalValue(value))
//
//    case .setAndRunButtonTapped:
//      let currentGoal = currentState.goalValue
//      let currentType = currentState.inputType
//
//      // Define the save operation using the injected use case
//      let saveOperation: Single<Bool>
//      switch currentType {
//      case .time:
//        saveOperation = goalUseCase.saveGoalTime(time: 30)
//      case .distance:
//        saveOperation = goalUseCase.saveGoalDistance(distance: 5)
//      }
//
//      // Create the sequence of mutations
//      return Observable.concat([
//        // 1. 로딩 시작
//        .just(Mutation.setLoading(true)),
//
//        // 2. 서버 통신 및 응답 처리
//        saveOperation
//          .map { success -> Mutation in
//            return .setSaveSuccess(success)
//          }
//          .catch { error in
//            print("Error saving goal: \(error)") // 에러 로깅
//            return .just(.setSaveError(error)) // 에러 상태 전파
//          }
//          .asObservable() // Single을 Observable로 변환
//          .flatMap { saveResultMutation -> Observable<Mutation> in
//            // 3. 서버 응답이 오면 로딩 종료 (성공/실패 무관)
//            // 이 시점에서 애니메이션 시작 여부는 VC가 saveSuccess 상태를 보고 결정
//            return Observable.concat([
//              .just(saveResultMutation), // 저장 결과 뮤테이션 전파
//              .just(Mutation.setLoading(false)) // 로딩 종료
//            ])
//          }
//      ])
//
//    case .backButtonTapped:
//      return .just(.setNavigation(.pop))
//
//    case .skipButtonTapped:
//      // For skip, we navigate without explicitly saving a goal via the UseCase.
//      // If a default goal (e.g., 0) should be saved on skip, add the use case call here.
//      return .just(.setNavigation(.showRunning)) // Modified: Removed arguments
//
//    case .viewDidAppear:
//      // No direct state mutation for this, but could be used for side effects
//      return .empty()
//    case .animationDidFinish:
//      return .just(.setNavigation(.showRunning))
//    }
//  }
//
//  // MARK: - Reduce (State Transformation)
//
//  func reduce(state: State, mutation: Mutation) -> State {
//    var newState = state
//    switch mutation {
//    case .setGoalValue(let value):
//      newState.goalValue = value
//      newState.saveSuccess = nil // Reset success status on new input
//      newState.saveError = nil // New: Reset error status on new input
//    case .setLoading(let isLoading):
//      newState.isLoading = isLoading
//    case .setSaveSuccess(let success):
//      newState.saveSuccess = success
//      newState.saveError = nil // Clear error on success
//    case .setSaveError(let error): // New: Handle error mutation
//      newState.saveError = error
//      newState.saveSuccess = false // Indicate failure
//    case .setNavigation(let target):
//      newState.navigationTarget = target // @Pulse will handle this one-time event
//    }
//    return newState
//  }
//}
