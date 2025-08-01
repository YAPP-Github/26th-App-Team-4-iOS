//
//  GoalAPI.swift
//  Data
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation
import Moya

public enum GoalAPI: BaseAPI {
  /// 러닝 동기 저장
  case savePurpose(runningPurpose: String)
  /// 목표 조회
  case goal
  /// 페이스 목표 저장 (밀리초)
  case savePace(paceGoalMs: Int)
  /// 주간 러닝 횟수 저장
  case saveRunningCount(weeklyRunningCount: Int)
  /// 시간 목표 설정
  case saveGoalTime(time: Int)
  /// 거리 목표 설정 (distance: 거리 목표(m))
  case saveGoalDistance(distance: Int)

  public var path: String {
    switch self {
    case .savePurpose: 
      return "/users/goals/purpose"
    case .goal:
      return "/users/goals"
    case .savePace:
      return"/users/goals/pace"
    case .saveRunningCount:
      return "/users/goals/weekly-run-count"
    case .saveGoalTime:
      return "/users/goals/time"
    case .saveGoalDistance:
      return "users/goals/distance"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .savePurpose: return .post
    case .goal: return .get
    case .savePace: return .post
    case .saveRunningCount: return .post
    case .saveGoalTime: return .post
    case .saveGoalDistance: return .post
    }
  }
  
  public var task: Task {
    switch self {
    case .savePurpose(let runningPurpose):
      return .requestParameters(parameters: ["runningPurpose": runningPurpose], encoding: JSONEncoding.default)
      
    case .goal:
      return .requestParameters(parameters: [:], encoding: URLEncoding.default)
      
    case .savePace(paceGoalMs: let paceGoalMs):
      return .requestParameters(parameters: ["pace": paceGoalMs], encoding: JSONEncoding.default)
      
    case .saveRunningCount(weeklyRunningCount: let weeklyRunningCount):
      return .requestParameters(parameters: ["count": weeklyRunningCount], encoding: JSONEncoding.default)
    case .saveGoalTime(time: let time):
      return .requestParameters(parameters: ["time": time], encoding: JSONEncoding.default)
    case .saveGoalDistance(distance: let distance):
      return .requestParameters(parameters: ["distanceMeterGoal": distance], encoding: JSONEncoding.default)
    }
  }
}
