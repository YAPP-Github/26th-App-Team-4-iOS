//
//  RunningGoalUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/7/25.
//

import RxSwift

public protocol RunningGoalUseCase {
  func getRunningGoal() -> Single<RunningGoal>
}

public final class RunningGoalUseCaseImpl: RunningGoalUseCase {
  private let goalRepository: GoalRepository

  public init(goalRepository: GoalRepository) {
    self.goalRepository = goalRepository
  }

  public func getRunningGoal() -> Single<RunningGoal> {
    return goalRepository.getRunningGoal()
  }
}
