//
//  UserInfo.swift
//  Domain
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation

public struct UserInfo {
  public let id: Int
  public let nickname: String
  public let email: String?
  public let provider: String
  
  public init(id: Int, nickname: String, email: String?, provider: String) {
    self.id = id
    self.nickname = nickname
    self.email = email
    self.provider = provider
  }
}
