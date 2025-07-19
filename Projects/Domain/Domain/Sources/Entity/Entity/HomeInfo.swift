//
//  HomeInfo.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

//
//  HomeInfo.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import Foundation

/// 달리기 홈 화면에 필요한 모든 정보를 하나로 묶은 도메인 모델
public struct HomeInfo {

  /// 사용자 고유 ID
  public let userId: Int
  /// 사용자 닉네임
  public let nickname: String

  /// 누적 총 달린 거리 (미터)
  public let totalDistance: Double
  /// 이번 주 달린 횟수
  public let thisWeekRunningCount: Int
  /// 최근 달리기 평균 페이스 (초 단위)
  public let recentPace: TimeInterval
  /// 최근 달린 거리 (미터)
  public let recentDistanceMeter: Double
  /// 최근 달린 시간 (초 단위)
  public let recentTime: TimeInterval

  /// 달리기 목적
  public let runningPurpose: RunningPurpose
  /// 주간 러닝 횟수 목표
  public let weeklyRunningCount: Int
  /// 목표 페이스 (초 단위)
  public let paceGoal: TimeInterval
  /// 거리 목표 (미터)
  public let distanceMeterGoal: Double
  /// 시간 목표 (초 단위)
  public let timeGoal: TimeInterval
}
