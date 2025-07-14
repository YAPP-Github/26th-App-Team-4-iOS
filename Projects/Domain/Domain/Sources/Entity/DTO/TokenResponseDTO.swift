//
//  TokenResponseDTO.swift
//  Domain
//
//  Created by JDeoks on 7/14/25.
//


public struct TokenResponseDTO: Codable {
  public let accessToken: String
  public let refreshToken: String
}

extension TokenResponseDTO {
  public func toDomain() -> TokenResponse {
    return TokenResponse(
      accessToken: accessToken,
      refreshToken: refreshToken
    )
  }
}
