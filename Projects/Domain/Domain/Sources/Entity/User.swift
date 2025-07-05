//
//  User.swift
//  Domain
//
//  Created by dong eun shin on 7/4/25.
//

import Foundation

public struct User: Codable, Equatable {
  public let id: String
  public let name: String
  public var isNew: Bool

  public init(id: String, name: String, isNew: Bool) {
    self.id = id
    self.name = name
    self.isNew = isNew
  }
}

public enum UserStatus: Equatable {
  case needsWalkthrough       // 워크스루 필요
  case loggedIn               // 로그인 완료 및 모든 설정 완료
}

