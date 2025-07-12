//
//  GoalAPI.swift
//  Data
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation
import Moya

public enum GoalAPI: BaseAPI {
  case purpose(runningPurpose: String)

  public var path: String {
    switch self {
    case .purpose: return "/goals/"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .purpose: return .post
    }
  }
  
  public var task: Task {
    switch self {
    case .purpose(let runningPurpose):
      return .requestParameters(parameters: ["runningPurpose": runningPurpose], encoding: JSONEncoding.default)
    }
  }
}
