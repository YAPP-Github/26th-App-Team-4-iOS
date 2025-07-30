//
//  RunningRecordList.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//


public struct RunningRecordList {
  public let summary: RecordSummary
  public let records: [RunningRecord]

  public init(summary: RecordSummary, records: [RunningRecord]) {
    self.summary = summary
    self.records = records
  }
}
