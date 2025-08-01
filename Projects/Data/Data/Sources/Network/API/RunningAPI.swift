//
//  RunningAPI.swift
//  Data
//
//  Created by dong eun shin on 8/1/25.
//

import Foundation
import Moya

public enum RunningAPI: BaseAPI {
  case saveRunningRecord(recordId: String)

  public var path: String {
    switch self {
    case .saveRunningRecord(let recordId): return "/running/\(recordId)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .saveRunningRecord: return .post
    }
  }

  public var headers: [String: String]? {
    return CommonNetworkHeaders.runningAPI
  }

  public var task: Task {
    switch self {
    case .saveRunningRecord:
      return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
    }
  }
}
