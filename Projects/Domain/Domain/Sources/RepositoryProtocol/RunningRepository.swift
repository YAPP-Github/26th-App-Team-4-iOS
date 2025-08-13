//
//  RunningRepository.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import CoreLocation

public protocol RunningRepository {
  func startRun(startLocation: CLLocation, timeStamp: Date) -> Single<Int?>
  func completeRun(recordId: Int, completionData: RunningCompletion) -> Single<Bool>
  func saveRunningRecordImage(recordId: Int) -> Single<String?>
}
