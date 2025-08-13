//
//  RunningRecordImageUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import CoreLocation

public protocol RunningRecordImageUseCase {
  func execute(recordId: Int) -> Single<String?>
}

public final class RunningRecordImageUseCaseImpl: RunningRecordImageUseCase {
  private let runningRepository: RunningRepository

  init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  public func execute(recordId: Int) -> Single<String?> {
    return runningRepository.saveRunningRecordImage(recordId: recordId)
  }
}
