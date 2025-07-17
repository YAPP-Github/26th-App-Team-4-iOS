//
//  LoginResultDTO.swift
//  Domain
//
//  Created by JDeoks on 7/14/25.
//


public struct LoginResultDTO: Codable {
  public let tokenResponse: TokenResponseDTO
  public let user: UserInfoDTO
  public let isNew: Bool
}

extension LoginResultDTO {
  public func toDomain() -> LoginResult {
    return LoginResult(
      tokenResponse: tokenResponse.toDomain(),
      user: user.toDomain(),
      isNew: isNew
    )
  }
}
