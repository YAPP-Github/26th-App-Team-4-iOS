//
//  UserAPI.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import Moya

public enum UserAPI: BaseAPI {
  case fetchUserProfile(userId: String)
  case updateUserProfile(userId: String, name: String)
  case saveOnboarding
  case type
  
  public var path: String {
    switch self {
    case .fetchUserProfile(let userId): return "/users/\(userId)"
    case .updateUserProfile(let userId, _): return "/users/\(userId)"
    case .saveOnboarding: return "/users"
    case .type: return "users/type"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchUserProfile: return .get
    case .updateUserProfile: return .put
    case .saveOnboarding: return .post
    case .type: return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .fetchUserProfile:
      return .requestPlain
    case .updateUserProfile(_, let name):
      return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
    case .saveOnboarding:
      return .requestParameters(parameters: ["answers": [:]], encoding: JSONEncoding.default)
    case .type:
      return .requestParameters(parameters: ["Authorization": ""], encoding: JSONEncoding.default)
    }
  }
}
