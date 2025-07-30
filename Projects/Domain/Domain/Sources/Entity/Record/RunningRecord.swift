//
//  RunningRecord.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//


import Foundation

/// 단일 러닝 기록 도메인 엔티티
public struct RunningRecord {
  public let recordId: Int
  public let title: String
  public let userId: Int
  public let startAt: Date
  /// 평균 페이스 (초 단위)
  public let averagePace: TimeInterval
  /// 총 거리 (미터)
  public let totalDistance: Double
  /// 총 시간 (초 단위)
  public let totalTime: TimeInterval
  public let imageURL: String?

  public init(
    recordId: Int,
    title: String,
    userId: Int,
    startAt: Date,
    averagePace: TimeInterval,
    totalDistance: Double,
    totalTime: TimeInterval,
    imageURL: String?
  ) {
    self.recordId = recordId
    self.title = title
    self.userId = userId
    self.startAt = startAt
    self.averagePace = averagePace
    self.totalDistance = totalDistance
    self.totalTime = totalTime
    self.imageURL = imageURL
  }
  
  static let dummys = [
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
    )
  ]
}
