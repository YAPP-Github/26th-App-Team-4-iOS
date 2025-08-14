//
//  RecordRepository.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import RxSwift


public protocol RecordRepository {
  func fetchRecordData(page: Int, size: Int) -> Single<RecordList?>
  func fetchRecordDetail(id: Int) -> Single<RunningRecord?>
  func deleteRecord(recordId: Int) -> Single<Bool>
}
