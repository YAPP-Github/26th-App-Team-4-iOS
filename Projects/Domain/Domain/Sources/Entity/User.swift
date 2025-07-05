//
//  User.swift
//  Domain
//
//  Created by dong eun shin on 7/4/25.
//

import Foundation

public struct User: Codable, Equatable {
  public let id: String
  public let username: String
  public let email: String?
  public var isOnboardingCompleted: Bool

  public init(id: String, username: String, email: String?, isOnboardingCompleted: Bool) {
    self.id = id
    self.username = username
    self.email = email
    self.isOnboardingCompleted = isOnboardingCompleted
  }
}

public enum UserStatus: Equatable {
  case needsWalkthrough       // 워크스루 필요
  case needsRegistrationOrLogin // 회원가입 또는 로그인 필요
  case needsOnboarding        // 온보딩 완료 필요 (회원가입은 했으나 추가 정보 입력 등)
  case loggedIn               // 로그인 완료 및 모든 설정 완료
}

