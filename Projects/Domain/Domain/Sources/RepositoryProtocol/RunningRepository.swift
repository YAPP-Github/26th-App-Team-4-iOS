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
  func saveRunningRecord(recordId: String, metadata: Data, image: UIImage) -> Single<Bool>
}
