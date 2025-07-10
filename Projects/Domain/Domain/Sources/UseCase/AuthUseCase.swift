//
//  AuthUseCase.swift
//  Domain
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift

public protocol AuthUseCaseType {
  func kakaoLogin() -> Single<SocialLoginResult>
  func appleLogin(identityToken: String, authCode: String?, email: String?, fullName: String?, userIdentifier: String) -> Single<SocialLoginResult>
}

public struct SocialLoginResult {
  public let accessToken: String
  public let refreshToken: String
  public let isNewUser: Bool
  
  public init(accessToken: String, refreshToken: String, isNewUser: Bool) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.isNewUser = isNewUser
  }
}

public struct SocialLoginInfo {
  public let provider: String
  public let token: String
  public let id: String?
  public let name: String?
  public let email: String?
  public let authorizationCode: String?
  
  public init(provider: String, token: String, id: String?, name: String?, email: String?, authorizationCode: String?) {
    self.provider = provider
    self.token = token
    self.id = id
    self.name = name
    self.email = email
    self.authorizationCode = authorizationCode
  }
}
