//
//  RecordUseCase.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import RxSwift

public protocol RecordUseCase {
  func fetchRecordData(page: Int, size: Int) -> Single<RunningRecordList>
  func fetchRecordDetial(id: Int) -> Single<RecordDetail>
}

public class RecordUseCaseImpl: RecordUseCase {

  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func fetchRecordData(page: Int, size: Int) -> Single<RunningRecordList> {
    return recordRepository.fetchRecordData(page: page, size: size)
  }
  
  public func fetchRecordDetial(id: Int) -> RxSwift.Single<RecordDetail> {
    return recordRepository.fetchRecordDetail(id: id)
  }
}
