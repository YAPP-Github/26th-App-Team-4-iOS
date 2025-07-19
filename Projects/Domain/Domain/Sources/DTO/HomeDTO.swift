//
//  HomeDTO.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import Foundation

// MARK: - HomeDTO
public struct HomeDTO: Codable {
  
  // MARK: - UserDTO
  public struct UserDTO: Codable {
    public let userId: Int
    public let nickname: String
  }
  
  // MARK: - RecordDTO
  public struct RecordDTO: Codable {
    /// 누적 총 달린 거리(m)
    public let totalDistance: Double?
    /// 이번 주 달린 횟수
    public let thisWeekRunningCount: Int?
    /// 최근 달리기 평균 페이스(밀리초)
    public let recentPace: Int?
    /// 최근 달린 거리(m)
    public let recentDistanceMeter: Double?
    /// 최근 달린 시간(밀리초)
    public let recentTime: Int?
  }
  
  // MARK: - UserGoalDTO
  public struct UserGoalDTO: Codable {
    ///달리기 목적
    public let runningPurpose: String?
    /// 주간 달리기 횟수 목표
    public let weeklyRunningCount: Int?
    /// 목표 페이스
    public let paceGoal: Int?
    /// 거리 목표(m)
    public let distanceMeterGoal: Double?
    /// 시간 목표
    public let timeGoal: Int?
  }

  public let user: UserDTO
  public let record: RecordDTO
  public let userGoal: UserGoalDTO
}

public extension HomeDTO {
  /// HomeDTO를 Domain의 HomeInfo로 변환합니다.
  func toDomain() -> HomeInfo {
    return HomeInfo(
      userId:               user.userId,
      nickname:             user.nickname,
      totalDistance:        record.totalDistance,
      thisWeekRunningCount: record.thisWeekRunningCount,
      recentPace:           record.recentPace.map { TimeInterval($0) / 1000 },
      recentDistanceMeter:  record.recentDistanceMeter,
      recentTime:           record.recentTime.map { TimeInterval($0) / 1000 },
      runningPurpose:       RunningPurpose(rawValue: userGoal.runningPurpose ?? "") ?? .health,
      weeklyRunningCount:   userGoal.weeklyRunningCount,
      paceGoal:             userGoal.paceGoal.map { TimeInterval($0) / 1000 },
      distanceMeterGoal:    userGoal.distanceMeterGoal,
      timeGoal:             userGoal.timeGoal.map { TimeInterval($0) / 1000 }
    )
  }
}
