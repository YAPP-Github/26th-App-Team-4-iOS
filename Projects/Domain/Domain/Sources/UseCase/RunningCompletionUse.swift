//
//  RunningStartUseCaseType.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import CoreLocation

public protocol RunningCompletionUseCaseType {
  func execute(
    recordId: Int,
    startAt: Date,
    runningPoints: [Point],
    totalTime: TimeInterval,
    totalDistance: Double,
    averagePace: TimeInterval,
    totalCalories: Int
  ) -> Single<Bool>
}

public final class RunningCompletionUseCase: RunningCompletionUseCaseType {
  private let runningRepository: RunningRepository

  init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  public func execute(
    recordId: Int,
    startAt: Date,
    runningPoints: [Point],
    totalTime: TimeInterval,
    totalDistance: Double,
    averagePace: TimeInterval,
    totalCalories: Int
  ) -> Single<Bool> {

    let completionData = RunningCompletion(
      runningPoints: runningPoints,
      totalTime: totalTime,
      totalCalories: totalCalories,
      averagePace: averagePace,
      totalDistance: totalDistance,
      startAt: startAt
    )

    return runningRepository.completeRun(recordId: recordId, completionData: completionData)
  }
}
