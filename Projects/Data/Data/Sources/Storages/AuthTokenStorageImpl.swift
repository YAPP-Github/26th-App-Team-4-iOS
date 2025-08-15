//
//  AuthTokenStorage.swift
//  Data
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation

public protocol AuthTokenStorage {
  func saveIdToken(_ token: String)
  func getIdToken() -> String?
  func saveAccessToken(_ token: String)
  func getAccessToken() -> String?
  func saveRefreshToken(_ token: String)
  func getRefreshToken() -> String?
  func clearTokens()
}

public class AuthTokenStorageImpl: AuthTokenStorage {

  public init() {}

  public func saveIdToken(_ token: String) {
    KeychainWrapper.shared.set(value: token, forKey: "idToken")
  }

  public func getIdToken() -> String? {
    KeychainWrapper.shared.get(forKey: "idToken")
  }

  public func saveAccessToken(_ token: String) {
    KeychainWrapper.shared.set(value: token, forKey: "accessToken")
  }

  public func getAccessToken() -> String? {
    KeychainWrapper.shared.get(forKey: "accessToken")
  }

  public func saveRefreshToken(_ token: String) {
    KeychainWrapper.shared.set(value: token, forKey: "refreshToken")
  }

  public func getRefreshToken() -> String? {
    KeychainWrapper.shared.get(forKey: "refreshToken")
  }

  public func clearTokens() {
    KeychainWrapper.shared.delete(forKey: "accessToken")
    KeychainWrapper.shared.delete(forKey: "refreshToken")
    KeychainWrapper.shared.delete(forKey: "idToken")
  }
}
