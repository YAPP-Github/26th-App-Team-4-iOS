//
//  RunningPurpose.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//


/// 달리기 목적 종류
public enum RunningPurpose: String, Codable, CaseIterable {
  /// 체중 감량 목적
  case weightLoss = "WEIGHT_LOSS_PURPOSE"
  /// 지구력 향상 목적
  case endurance = "DAILY_STRENGTH_IMPROVEMENT"
  /// 건강 관리 목적
  case health = "HEALTH_MAINTENANCE_PURPOSE"
  /// 대회 준비 목적
  case competitionPreparation = "COMPETITION_PREPARATION"
  
  public var displayName: String {
    switch self {
    case .weightLoss:
      return "다이어트"
    case .endurance:
      return "체력 증진"
    case .health:
      return "건강 관리"
    case .competitionPreparation:
      return "대회 준비"
    }
  }
}
