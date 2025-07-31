//
//  GoalUseCase.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import RxSwift

public protocol GoalUseCase {
  func fetchRunningGoal() -> Single<PaceRunningCount>
  func savePace(second: Int) -> Single<Bool>
  func saveRunningCount(count: Int) -> Single<Bool>
  func saveGoalTime(time: Int) -> Single<Bool>
}

public final class GoalUseCaseImpl: GoalUseCase {

  private let goalRepository: GoalRepository
  
  public init(goalRepository: GoalRepository) {
    self.goalRepository = goalRepository
  }
  
  public func fetchRunningGoal() -> Single<PaceRunningCount> {
    return goalRepository.fetchPaceRunningCount()
  }
  
  public func savePace(second: Int) -> RxSwift.Single<Bool> {
    let paceGoalMS = second * 1000
    return goalRepository.savePaceGoal(paceGoalMS: paceGoalMS)
  }
  
  public func saveRunningCount(count: Int) -> RxSwift.Single<Bool> {
    return goalRepository.saveRunningCount(count: count)
  }

  public func saveGoalTime(time: Int) -> RxSwift.Single<Bool> {
    return goalRepository.saveGoalTime(time: time)
  }
}
