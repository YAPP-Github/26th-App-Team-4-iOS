//
//  UserAPI.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import Moya

public enum UserAPI: BaseAPI {
  case fetchMyProfile
  case saveRunnerType(type: String)
  case updateUserProfile(userId: String, name: String)
  case saveOnboarding(answers: [[String: Any]])
  case type
  case deleteAccount(reason: String)
  
  public var path: String {
    switch self {
    case .fetchMyProfile: return "/users"
    case .saveRunnerType: return "/users/type"
    case .updateUserProfile(let userId, _): return "/users/\(userId)"
    case .saveOnboarding: return "/users/onboarding"
    case .type: return "/users/type"
    case .deleteAccount: return "/users"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchMyProfile: return .get
    case .saveRunnerType: return .put
    case .updateUserProfile: return .put
    case .saveOnboarding: return .post
    case .type: return .get
    case .deleteAccount: return .delete
    }
  }
  
  public var task: Task {
    switch self {
    case .fetchMyProfile:
      return .requestPlain
      
    case let .saveRunnerType(type):
      return .requestParameters(parameters: ["runnerType": type], encoding: JSONEncoding.default)
      
    case .updateUserProfile(_, let name):
      return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
      
    case let .saveOnboarding(answer):
      print("UserAPI - \(#function)")
      print(answer)
      return .requestParameters(parameters: ["answers": answer], encoding: JSONEncoding.default)
      
    case .type:
      return .requestParameters(parameters: [:], encoding: URLEncoding.default)
      
    case let .deleteAccount(reason):
      return .requestParameters(parameters: ["reason": reason], encoding: JSONEncoding.default)
    }
  }
}
