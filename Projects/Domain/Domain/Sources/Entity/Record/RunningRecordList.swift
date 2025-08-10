//
//  RunningRecordList.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation


public struct RunningRecordList: Equatable {
  public let summary: RecordSummary
  public let records: [RunningRecord]

  public init(summary: RecordSummary, records: [RunningRecord]) {
    self.summary = summary
    self.records = records
  }
  
  public static let dummy = RunningRecordList(
    summary: RecordSummary(
        recordCount: 10,
        totalDistance: 120.0,
        totalTime: 32487, // 1시간
        totalCalories: 500,
        averagePace: 300, // 5분
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
        imageURL: "https://firebasestorage.googleapis.com/v0/b/maumnote-dev.firebasestorage.app/o/adfhdgsg.png?alt=media&token=8b2f3a4b-1c2a-4658-acc8-1af8cd070800"
      ),
      RunningRecord(
        recordId: 2,
        title: "저녁 러닝",
        userId: 1,
        startAt: Date().addingTimeInterval(-3600), // 한 시간 전
        averagePace: 320, // 5분 20초 페이스
        totalDistance: 8000, // 8km
        totalTime: 2560, // 약 42분
        imageURL: "https://firebasestorage.googleapis.com/v0/b/maumnote-dev.firebasestorage.app/o/adfhdgsg.png?alt=media&token=8b2f3a4b-1c2a-4658-acc8-1af8cd070800"
      ),
      RunningRecord(
        recordId: 2,
        title: "점심 러닝",
        userId: 1,
        startAt: Date().addingTimeInterval(-3600), // 한 시간 전
        averagePace: 320, // 5분 20초 페이스
        totalDistance: 8000, // 8km
        totalTime: 2560, // 약 42분
        imageURL: "https://firebasestorage.googleapis.com/v0/b/maumnote-dev.firebasestorage.app/o/adfhdgsg.png?alt=media&token=8b2f3a4b-1c2a-4658-acc8-1af8cd070800"
      )
    ]
  )
}
