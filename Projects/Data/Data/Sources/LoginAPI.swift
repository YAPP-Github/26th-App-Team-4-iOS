//
//  LoginAPI.swift
//  Data
//
//  Created by dong eun shin on 7/5/25.
//

import Foundation
import Moya

public enum LoginAPI {
  case socialLogin(provider: String, token: String)
}

extension LoginAPI: TargetType {
  public var baseURL: URL { URL(string: "http://fitrun.p-e.kr")! }
  public var path: String {
    switch self {
    case .socialLogin(let provider, _):
      return "/api/v1/auth/login/\(provider)"
    }
  }
  public var method: Moya.Method {
    switch self {
    case .socialLogin:
      return .post
    }
  }
  public var task: Task {
    switch self {
    case let .socialLogin(_, token):
      return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
    }
  }
  public var headers: [String : String]? {
    ["Content-Type": "application/json"]
  }
}
