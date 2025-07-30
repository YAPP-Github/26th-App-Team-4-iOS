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
}
