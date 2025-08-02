//
//  RunningRecordUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import CoreLocation

public protocol RunningRecordUseCase {
  func saveRunningRecord(recordId: String, image: UIImage) -> Single<Bool>
}

public final class RunningRecordUseCaseImpl: RunningRecordUseCase {

  private let repository: RunningRepository

  public init(repository: RunningRepository) {
    self.repository = repository
  }

  public func saveRunningRecord(recordId: String, image: UIImage) -> Single<Bool>
 {
    return repository.saveRunningRecord(recordId: recordId, metadata: , image: image)
  }
}
