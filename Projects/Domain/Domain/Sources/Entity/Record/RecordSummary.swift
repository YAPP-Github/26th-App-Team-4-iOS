//
//  RecordSummary.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation


public struct RecordSummary {
  /// 전체 기록 개수
  public let recordCount: Int
  /// 총 이동 거리(m)
  public let totalDistance: Double
  /// 총 러닝 시간 밀리초 단위
  public let totalTime: TimeInterval   // 초 단위
  /// 총 소모 칼로리
  public let totalCalories: Int
  /// 평균 페이스 밀리초 단위
  public let averagePace: TimeInterval // 초 단위
  // 시간 목표 달성 횟수
  public let timeGoalAchievedCount: Int
  /// 거리 목표 달성 횟수
  public let distanceGoalAchievedCount: Int
  
  static let dummy = RecordSummary(
    recordCount: 10,
    totalDistance: 5000.0,
    totalTime: 3600000, // 1시간
    totalCalories: 500,
    averagePace: 300000, // 5분
    timeGoalAchievedCount: 3,
    distanceGoalAchievedCount: 2
  )
}
