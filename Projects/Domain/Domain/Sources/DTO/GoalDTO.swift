//
//  GoalDTO.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import Foundation

public struct GoalDTO: Codable {
  /// 목표 고유 ID
  public let goalId: Int?
  /// 사용자 고유 ID
  public let userId: Int?
  /// 달리기 목적
  public let runningPurpose: String?
  /// 주간 러닝 횟수 목표
  public let weeklyRunningCount: Int?
  /// 목표 페이스 (밀리초)
  public let paceGoal: Int?
  /// 거리 목표 (미터)
  public let distanceMeterGoal: Double?
  /// 시간 목표 (밀리초)
  public let timeGoal: Int?
}

extension GoalDTO {
  /// GoalDTO를 도메인 모델로 변환
  public func toPaceRunningCount() -> PaceRunningCount {
    return PaceRunningCount(
      weeklyRunningCount: weeklyRunningCount,
      paceGoal: paceGoal.map { Int(TimeInterval($0) / 1000) }
    )
  }
}
