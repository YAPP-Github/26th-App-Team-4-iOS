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
  
  /// 기본적으로 HomeAPI를 사용합니다.
  public init(provider: NetworkProvider<RecordAPI> = .init()) {
    self.provider = provider
  }
    
  public func fetchRecordData(page: Int, size: Int) -> Single<RunningRecordList> {
    return .just(RunningRecordList.dummy)
  }
  
  public func fetchRecordDetail(id: Int) -> RxSwift.Single<Domain.RecordDetail> {
    return .just(RecordDetail.dummy)
  }
}
