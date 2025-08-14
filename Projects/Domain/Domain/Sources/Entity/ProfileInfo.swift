//
//  ProfileInfo.swift
//  Domain
//
//  Created by JDeoks on 8/14/25.
//

public struct ProfileInfo: Equatable {
  public let userId: Int
  public let nickname: String
  public let email: String
  public let provider: String
  public let runnerType: RunnerType
  public let goal: GoalInfo
}

public struct GoalInfo: Equatable {
  public let goalId: Int
  public let runningPurpose: RunningPurpose
  public let weeklyRunningCount: Int?
  public let paceGoal: Int?
  public let distanceMeterGoal: Double?
  public let timeGoal: Int?
  public let runnerType: RunnerType
}

public enum RunnerType: String, Decodable {
  case beginner = "BEGINNER"
  case intermediate = "INTERMEDIATE"
  case expert = "EXPERT"
   
  public var displayName: String {
    switch self {
    case .beginner:
      return "워밍업 러너"
    case .intermediate:
      return "루틴"
    case .expert:
      return "챌린저"
    }
  }
}
