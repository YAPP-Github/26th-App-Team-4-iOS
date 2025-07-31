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
