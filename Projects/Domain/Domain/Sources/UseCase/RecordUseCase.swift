//
//  RecordUseCase.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import RxSwift

public protocol RecordUseCase {
  func fetchRecordData(page: Int, size: Int) -> Single<RecordList?>
  func fetchRecordDetial(id: Int) -> Single<RunningRecord?>
}

public class RecordUseCaseImpl: RecordUseCase {

  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func fetchRecordData(page: Int, size: Int) -> Single<RecordList?> {
    return recordRepository.fetchRecordData(page: page, size: size)
  }
  
  public func fetchRecordDetial(id: Int) -> RxSwift.Single<RunningRecord?> {
    return recordRepository.fetchRecordDetail(id: id)
  }
}
