//
//  RunningPurpose.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//


/// 달리기 목적 종류
public enum RunningPurpose: String, Codable {
  /// 체중 감량 목적
  case weightLoss = "WEIGHT_LOSS_PURPOSE"
  /// 지구력 향상 목적
  case endurance = "DAILY_STRENGTH_IMPROVEMENT"
  /// 건강 관리 목적
  case health = "HEALTH_MAINTENANCE_PURPOSE"
  /// 대회 준비 목적
  case competitionPreparation = "COMPETITION_PREPARATION"
}
