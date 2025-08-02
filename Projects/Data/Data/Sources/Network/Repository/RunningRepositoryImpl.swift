//
//  RunningRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on on 8/2/25.
//

import UIKit
import Moya
import RxSwift
import CoreLocation
import Domain

public final class RunningRepositoryImpl: RunningRepository {

  private let provider: NetworkProvider<RunningAPI>

  public init(provider: NetworkProvider<RunningAPI> = .init()) {
    self.provider = provider
  }

  public func saveRunningRecord(
    recordId: String,
    metadata: Data,
    image: UIImage) -> Single<Bool> {
      return provider
        .request(.saveRunningRecord(recordId: recordId, metadata: metadata, image: image))
        .filter(statusCodes: 200..<300)
        .map(APIResponse<RunningRecordDTO>.self)
        .map { $0.code == "SUCCESS" }
        .asSingle()
    }
}
