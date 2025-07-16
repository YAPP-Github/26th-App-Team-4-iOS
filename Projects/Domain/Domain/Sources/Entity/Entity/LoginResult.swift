//
//  LoginResult.swift
//  Domain
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation

public struct LoginResult {
  public let tokenResponse: TokenResponse
  public let user: UserInfo
  public let isNew: Bool
  
  public init(tokenResponse: TokenResponse, user: UserInfo, isNew: Bool) {
    self.tokenResponse = tokenResponse
    self.user = user
    self.isNew = isNew
  }
}

public struct TokenResponse {
  public let accessToken: String
  public let refreshToken: String
  
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
