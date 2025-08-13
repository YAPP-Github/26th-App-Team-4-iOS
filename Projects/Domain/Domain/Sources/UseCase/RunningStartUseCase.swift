//
//  RunningStartUseCaseType.swift
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

public final class RunningStartUseCase: RunningStartUseCaseType {
  private let runningRepository: RunningRepository

  init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  public func execute(startLocation: CLLocation, timeStamp: Date) -> Single<Int?> {
    return runningRepository.startRun(startLocation: startLocation, timeStamp: timeStamp)
  }
}
