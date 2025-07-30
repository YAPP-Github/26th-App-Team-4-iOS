//
//  RunningRecordList.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//


import Foundation

/// 여러 개의 러닝 기록과 요약 통계를 담는 도메인 엔티티
public struct RunningRecordList {
  /// 개별 기록 배열
  public let records: [RunningRecord]
  /// 전체 기록 개수
  public let recordCount: Int
  /// 누적 총 거리 (미터)
  public let totalDistance: Double
  /// 누적 총 시간 (초 단위)
  public let totalTime: TimeInterval
  /// 누적 소모 칼로리
  public let totalCalories: Int
  /// 전체 평균 페이스 (초 단위)
  public let averagePace: TimeInterval
  /// 시간 목표 달성 횟수
  public let timeGoalAchievedCount: Int
  /// 거리 목표 달성 횟수
  public let distanceGoalAchievedCount: Int

  public init(
    records: [RunningRecord],
    recordCount: Int,
    totalDistance: Double,
    totalTime: TimeInterval,
    totalCalories: Int,
    averagePace: TimeInterval,
    timeGoalAchievedCount: Int,
    distanceGoalAchievedCount: Int
  ) {
    self.records = records
    self.recordCount = recordCount
    self.totalDistance = totalDistance
    self.totalTime = totalTime
    self.totalCalories = totalCalories
    self.averagePace = averagePace
    self.timeGoalAchievedCount = timeGoalAchievedCount
    self.distanceGoalAchievedCount = distanceGoalAchievedCount
  }
}
