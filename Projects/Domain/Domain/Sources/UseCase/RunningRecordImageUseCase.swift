//
//  RunningRecordImageUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import NMapsMap

public protocol RunningRecordImageUseCase {
  func uploadImage(_ image: UIImage, recordId: Int) -> Single<String?>
}

public final class RunningRecordImageUseCaseImpl: RunningRecordImageUseCase {
  private let runningRepository: RunningRepository
  
  public init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  public func uploadImage(_ image: UIImage, recordId: Int) -> Single<String?> {
    runningRepository.saveRunningRecordImage(recordId: recordId, image: image)
  }
}
