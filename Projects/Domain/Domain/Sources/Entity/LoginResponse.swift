//
//  LoginResponse.swift
//  Domain
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation

public struct APIResponse<T: Codable>: Codable {
  public let code: String
  public let result: T?
  public let timeStamp: String
}

public struct LoginResultDTO: Codable {
  public let tokenResponse: TokenResponseDTO
  public let user: UserInfoDTO
  public let isNew: Bool
}

public struct TokenResponseDTO: Codable {
  public let accessToken: String
  public let refreshToken: String
}

public struct UserInfoDTO: Codable {
  public let id: Int
  public let nickname: String
  public let email: String?
  public let provider: String
}


// MARK: - Data Layer -> Domain Layer Mapping
extension LoginResultDTO {
  public func toDomain() -> LoginResult {
    return LoginResult(
      tokenResponse: tokenResponse.toDomain(),
      user: user.toDomain(),
      isNew: isNew
    )
  }
}

extension TokenResponseDTO {
  public func toDomain() -> TokenResponse {
    return TokenResponse(
      accessToken: accessToken,
      refreshToken: refreshToken
    )
  }
}

extension UserInfoDTO {
  public func toDomain() -> UserInfo {
    return UserInfo(
      id: id,
      nickname: nickname,
      email: email,
      provider: provider
    )
  }
}
