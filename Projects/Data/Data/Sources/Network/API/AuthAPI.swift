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
}
