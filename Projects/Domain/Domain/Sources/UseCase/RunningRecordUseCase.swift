//
//  RunningRecordUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import CoreLocation

public protocol RunningStartUseCaseType {
  func execute(startLocation: CLLocation, timeStamp: Date) -> Single<Int?>
}

// 달리기 시작 로직을 담당하는 UseCase
public final class RunningStartUseCase: RunningStartUseCaseType {
  private let runningRepository: RunningRepository

  init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  // Repository에서 이미 변환된 도메인 객체를 받으므로, 변환 로직을 제거합니다.
  public func execute(startLocation: CLLocation, timeStamp: Date) -> Single<Int?> {
    return runningRepository.startRun(startLocation: startLocation, timeStamp: timeStamp)
  }
}

public protocol RunningCompletionUseCaseType {
  func execute(
    recordId: String,
    startAt: Date,
    runningPoints: [RunningPoint],
    totalTime: TimeInterval,
    totalDistance: Double,
    averagePace: TimeInterval,
    totalCalories: Int
  ) -> Single<Bool> // Observable -> Single로 변경
}

// 러닝 완료 데이터를 변환하고 업로드하는 비즈니스 로직을 담당하는 UseCase
public final class RunningCompletionUseCase: RunningCompletionUseCaseType {
  private let runningRepository: RunningRepository

  init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  // UseCase 내에서 모든 DTO 변환 및 데이터 준비를 수행합니다.
  public func execute(
    recordId: String,
    startAt: Date,
    runningPoints: [RunningPoint],
    totalTime: TimeInterval,
    totalDistance: Double,
    averagePace: TimeInterval,
    totalCalories: Int
  ) -> Single<Bool> {

    // UseCase 내에서 DTO 대신 도메인 모델(RunningCompletionData)을 생성합니다.
    let completionData = RunningCompletionData(
      runningPoints: runningPoints,
      totalTime: totalTime,
      totalCalories: totalCalories,
      averagePace: averagePace,
      totalDistance: totalDistance,
      startAt: startAt
    )

    // Repository를 통해 API 호출 시 도메인 모델을 전달합니다.
    return runningRepository.completeRun(recordId: recordId, completionData: completionData)
  }
}
