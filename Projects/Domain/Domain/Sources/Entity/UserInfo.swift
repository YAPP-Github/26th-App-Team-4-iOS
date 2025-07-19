//
//  UserInfo.swift
//  Domain
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation

public struct UserInfo {
  public let userId: Int
  public let nickname: String
  public let email: String?
  public let provider: String
  
  public init(userId: Int, nickname: String, email: String?, provider: String) {
    self.userId = userId
    self.nickname = nickname
    self.email = email
    self.provider = provider
  }
}
