//
//  AuthAPI.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import Moya
import Domain

public enum AuthAPI: BaseAPI {
  case appleLogin(idToken: String)
  case kakaoLogin(idToken: String)
  case refreshToken(refreshToken: String)

  public var path: String {
    switch self {
    case .appleLogin:
      return "/auth/login/apple"
    case .kakaoLogin:
      return "/auth/login/kakao"
    case .refreshToken:
      return "/auth/refresh"
    }
  }

  public var method: Moya.Method {
    return .post
  }

  public var headers: [String: String]? {
    switch self {
    case .appleLogin:
      return CommonNetworkHeaders.default
    case .kakaoLogin:
      return CommonNetworkHeaders.default
    case .refreshToken:
      return CommonNetworkHeaders.refreshToken
    }
  }

  public var task: Moya.Task {
    switch self {
    case let .appleLogin(idToken):
      return .requestParameters(parameters: ["idToken": idToken], encoding: JSONEncoding.default)
    case let .kakaoLogin(idToken):
      return .requestParameters(parameters: ["idToken": idToken], encoding: JSONEncoding.default)
    case .refreshToken:
      return .requestPlain
    }
  }
}
