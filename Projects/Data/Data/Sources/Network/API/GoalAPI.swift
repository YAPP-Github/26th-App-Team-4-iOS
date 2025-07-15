//
//  GoalAPI.swift
//  Data
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation
import Moya

public enum GoalAPI: BaseAPI {
  case savePurpose(runningPurpose: String)

  public var path: String {
    switch self {
    case .savePurpose: return "/users/goals/purpose"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .savePurpose: return .post
    }
  }
  
  public var task: Task {
    switch self {
    case .savePurpose(let runningPurpose):
      return .requestParameters(parameters: ["runningPurpose": runningPurpose], encoding: JSONEncoding.default)
    }
  }
}
