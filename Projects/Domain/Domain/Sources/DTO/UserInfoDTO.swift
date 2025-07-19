//
//  UserInfoDTO.swift
//  Domain
//
//  Created by JDeoks on 7/14/25.
//


public struct UserInfoDTO: Codable {
  public let userId: Int
  public let nickname: String
  public let email: String?
  public let provider: String
}

extension UserInfoDTO {
  public func toDomain() -> UserInfo {
    return UserInfo(
      userId: userId,
      nickname: nickname,
      email: email,
      provider: provider
    )
  }
}
