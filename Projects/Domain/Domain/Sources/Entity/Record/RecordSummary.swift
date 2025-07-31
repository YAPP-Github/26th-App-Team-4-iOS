//
//  RecordSummary.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation


public struct RecordSummary: Equatable {
  /// 전체 기록 개수
  public let recordCount: Int
  /// 총 이동 거리(m)
  public let totalDistance: Double
  /// 총 러닝 시간 초 단위
  public let totalTime: TimeInterval
  /// 총 소모 칼로리
  public let totalCalories: Int
  /// 평균 페이스 초 단위
  public let averagePace: TimeInterval
  // 시간 목표 달성 횟수
  public let timeGoalAchievedCount: Int
  /// 거리 목표 달성 횟수
  public let distanceGoalAchievedCount: Int
  
  public init(
    recordCount: Int,
    totalDistance: Double,
    totalTime: TimeInterval,
    totalCalories: Int,
    averagePace: TimeInterval,
    timeGoalAchievedCount: Int,
    distanceGoalAchievedCount: Int
  ) {
    self.recordCount = recordCount
    self.totalDistance = totalDistance
    self.totalTime = totalTime
    self.totalCalories = totalCalories
    self.averagePace = averagePace
    self.timeGoalAchievedCount = timeGoalAchievedCount
    self.distanceGoalAchievedCount = distanceGoalAchievedCount
  }
}
