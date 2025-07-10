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
  case login(id: String, pw: String)
  case register(id: String, pw: String, name: String)
  case refreshToken(refreshToken: String)
  case socialLogin(info: SocialLoginInfo)
  
  public var path: String {
    switch self {
    case .login: return "/auth/login"
    case .register: return "/auth/register"
    case .refreshToken: return "/auth/refresh"
    case .socialLogin: return "/auth/social-login"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .login, .register, .refreshToken, .socialLogin: return .post
    }
  }
  
  public var task: Task {
    switch self {
    case .login(let id, let pw):
      return .requestParameters(parameters: ["id": id, "password": pw], encoding: JSONEncoding.default)
    case .register(let id, let pw, let name):
      return .requestParameters(parameters: ["id": id, "password": pw, "name": name], encoding: JSONEncoding.default)
    case .refreshToken(let refreshToken):
      return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
    case .socialLogin(let info):
      var parameters: [String: Any] = [
        "provider": info.provider,
        "token": info.token
      ]
      if let id = info.id { parameters["id"] = id }
      if let name = info.name { parameters["name"] = name }
      if let email = info.email { parameters["email"] = email }
      if let authCode = info.authorizationCode { parameters["authorizationCode"] = authCode }
      return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
  }
}
