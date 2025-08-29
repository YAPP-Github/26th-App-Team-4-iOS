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
  func saveGoalDistance(distance: Int) -> Single<Bool>
  func getRecommendPace() -> Single<RecommendPace>
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
    let goalTimeMS = time * 60 * 1000
    return goalRepository.saveGoalTime(time: goalTimeMS)
  }

  public func saveGoalDistance(distance: Int) -> RxSwift.Single<Bool> {
    let distanceGoalM = distance * 1000
    return goalRepository.saveGoalDistance(distance: distanceGoalM)
  }

  public func getRecommendPace() -> Single<RecommendPace> {
    return goalRepository.getRecommendPace()
  }
}
