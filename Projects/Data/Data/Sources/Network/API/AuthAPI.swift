//
//  AuthAPI.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import Moya
import Domain

public enum AuthAPI {
  case appleLogin(idToken: String)
  case kakaoLogin(idToken: String)
  case refreshToken(refreshToken: String)
}

extension AuthAPI: TargetType {
  public var baseURL: URL {
    guard let url = URL(string: "http://fitrun.p-e.kr/api/v1/auth") else {
      fatalError("Invalid Base URL: Please set YOUR_BACKEND_SERVER_BASE_URL in AuthAPI.")
    }
    return url
  }

  public var path: String {
    switch self {
    case .appleLogin:
      return "/login/apple"
    case .kakaoLogin:
      return "/login/kakao"
    case .refreshToken:
      return "refresh"
    }
  }

  public var method: Moya.Method {
    return .post
  }

  public var task: Moya.Task {
    switch self {
    case let .appleLogin(idToken):
      return .requestParameters(parameters: ["idToken": idToken], encoding: JSONEncoding.default)
    case let .kakaoLogin(idToken):
      return .requestParameters(parameters: ["idToken": idToken], encoding: JSONEncoding.default)
    case .refreshToken(refreshToken: let refreshToken):
      return .requestParameters(parameters: ["Authorization": refreshToken], encoding: JSONEncoding.default)
    }
  }

  public var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}
