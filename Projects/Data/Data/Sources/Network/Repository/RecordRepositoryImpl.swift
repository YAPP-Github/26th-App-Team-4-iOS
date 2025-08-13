//
//  RecordRepositoryImpl.swift
//  Data
//
//  Created by JDeoks on 7/31/25.
//


import Foundation
import Moya
import RxSwift

import Domain

public final class RecordRepositoryImpl: RecordRepository {

  private let provider: NetworkProvider<RecordAPI>
  
  public init(provider: NetworkProvider<RecordAPI> = .init()) {
    self.provider = provider
  }
    
  public func fetchRecordData(page: Int, size: Int) -> Single<RecordList?> {
    return provider
      .request(.records(page: page, size: size))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<RunningRecordListDTO>.self)
      .map { response in
        guard let result = response.result else {
          throw NSError(domain: "RecordRepositoryImpl", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result found in response"])
        }
        return result.toEntity()
      }
      .asSingle()
  }
  
  public func fetchRecordDetail(id: Int) -> Single<RunningRecord?> {
    return provider
      .request(.record(recordId: id))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<RunningRecordDTO>.self)
      .map { response in
        guard let result = response.result else {
          throw NSError(domain: "RecordRepositoryImpl", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result found in response"])
        }
        print(">>>>resultresultresult", result)
        return result.toDomain()
      }
      .asSingle()
  }
}
