//
//  RecordRepository.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import RxSwift


public protocol RecordRepository {
  func fetchRecordData(page: Int, size: Int) -> Single<RunningRecordList>
  func fetchRecordDetail(id: Int) -> Single<RecordDetail>
}
