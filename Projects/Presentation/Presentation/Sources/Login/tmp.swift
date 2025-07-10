//
//  tmp.swift
//  Presentation
//
//  Created by dong eun shin on 7/8/25.
//

import UIKit

struct ServerResponse<T: Codable>: Codable {
  let success: Bool
  let message: String?
  let data: T?
}

struct LoginData: Codable {
  let token: String
  let userId: String?
}

import Foundation
import Moya
import RxSwift

// MARK: - Server API Definition
enum AuthAPI {
  case appleLogin(idToken: String, user: String)
  case kakaoLogin(accessToken: String)
  case refreshToken(refreshToken: String)
}

extension AuthAPI: TargetType {
  var baseURL: URL {
    guard let url = URL(string: "http://fitrun.p-e.kr/api/v1/auth") else {
      fatalError("Invalid Base URL: Please set YOUR_BACKEND_SERVER_BASE_URL in AuthAPI.")
    }
    return url
  }

  var path: String {
    switch self {
    case .appleLogin:
      return "/login/apple"
    case .kakaoLogin:
      return "/login/kakao"
    case .refreshToken:
      return "refresh"
    }
  }

  var method: Moya.Method {
    return .post
  }

  var task: Moya.Task {
    switch self {
    case let .appleLogin(idToken, _):
      return .requestParameters(parameters: ["idToken": idToken], encoding: JSONEncoding.default)
    case let .kakaoLogin(accessToken):
      return .requestParameters(parameters: ["idToken": accessToken], encoding: JSONEncoding.default)
    case .refreshToken(refreshToken: let refreshToken):
      return .requestParameters(parameters: ["Authorization": refreshToken], encoding: JSONEncoding.default)
    }
  }

  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}

// MARK: - API Provider Instance
let authProvider = MoyaProvider<AuthAPI>()


// LoginResponse.swift
import Foundation

struct ApiResponse<T: Codable>: Codable {
  let code: String
  let result: T?
  let timeStamp: String
}

struct LoginResult: Codable {
  let tokenResponse: TokenResponse
  let user: UserInfo
  let isNew: Bool
}

struct TokenResponse: Codable {
  let accessToken: String
  let refreshToken: String
}

struct UserInfo: Codable {
  let id: Int
  let nickname: String
  let email: String?
  let provider: String // "APPLE" 또는 "KAKAO" 등
}
