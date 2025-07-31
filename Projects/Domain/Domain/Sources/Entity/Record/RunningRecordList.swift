//
//  RunningRecordList.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation


public struct RunningRecordList {
  public let summary: RecordSummary
  public let records: [RunningRecord]

  public init(summary: RecordSummary, records: [RunningRecord]) {
    self.summary = summary
    self.records = records
  }
  
  public static let dummy = RunningRecordList(
    summary: RecordSummary(
        recordCount: 10,
        totalDistance: 5000.0,
        totalTime: 3600000, // 1시간
        totalCalories: 500,
        averagePace: 300000, // 5분
        timeGoalAchievedCount: 3,
        distanceGoalAchievedCount: 2
      ),
    records: [
      RunningRecord(
        recordId: 1,
        title: "아침 러닝",
        userId: 1,
        startAt: Date(),
        averagePace: 300, // 5분 페이스
        totalDistance: 5000, // 5km
        totalTime: 1500, // 25분
        imageURL: "https://example.com/image1.jpg"
      ),
      RunningRecord(
        recordId: 2,
        title: "저녁 러닝",
        userId: 1,
        startAt: Date().addingTimeInterval(-3600), // 한 시간 전
        averagePace: 320, // 5분 20초 페이스
        totalDistance: 8000, // 8km
        totalTime: 2560, // 약 42분
        imageURL: "https://example.com/image2.jpg"
      ),
      RunningRecord(
        recordId: 2,
        title: "점심 러닝",
        userId: 1,
        startAt: Date().addingTimeInterval(-3600), // 한 시간 전
        averagePace: 320, // 5분 20초 페이스
        totalDistance: 8000, // 8km
        totalTime: 2560, // 약 42분
        imageURL: "https://example.com/image2.jpg"
      )
    ]
  )
}
