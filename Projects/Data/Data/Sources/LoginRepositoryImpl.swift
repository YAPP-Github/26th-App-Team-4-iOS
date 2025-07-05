//
//  AppleLoginRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on 6/26/25.
//

import Foundation
import Domain
import AuthenticationServices

public final class LoginRepositoryImpl: LoginRepository {
  public init() {}

  public func saveUserID(_ id: String) {
    UserDefaults.standard.set(id, forKey: "user_id")
  }
}
