//
//  ProfileInfoDTO.swift
//  Domain
//
//  Created by JDeoks on 8/14/25.
//


public struct ProfileInfoDTO: Codable {
  
  let user: User
  let goal: Goal?
  
  struct User: Codable {
    let userId: Int
    let nickname: String
    let email: String
    let provider: String
    let runnerType: String
  }

  struct Goal: Codable {
    let goalId: Int?
    let userId: Int?
    let runningPurpose: String?
    let weeklyRunningCount: Int?
    let paceGoal: Int?
    let distanceMeterGoal: Double?
    let timeGoal: Int?
    let runnerType: String?
  }
}

extension ProfileInfoDTO {
  public func toDomain() -> ProfileInfo {

    return ProfileInfo(
      userId: user.userId,
      nickname: user.nickname,
      email: user.email,
      provider: user.provider,
      runnerType: RunnerType(rawValue: user.runnerType) ?? .beginner,
      goal: GoalInfo(
        goalId: goal?.goalId ?? 0,
        runningPurpose: RunningPurpose(rawValue: goal?.runningPurpose ?? "") ?? .health,
        weeklyRunningCount: goal?.weeklyRunningCount,
        paceGoal: goal?.paceGoal,
        distanceMeterGoal: goal?.distanceMeterGoal,
        timeGoal: goal?.timeGoal,
        runnerType: RunnerType(rawValue: goal?.runnerType ?? "") ?? .beginner
      )
    )
  }
}
