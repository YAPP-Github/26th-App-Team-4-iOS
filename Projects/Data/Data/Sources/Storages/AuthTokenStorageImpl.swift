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
    UserDefaults.standard.set(token, forKey: "idToken")
  }

  public func getIdToken() -> String? {
    return UserDefaults.standard.string(forKey: "idToken")
  }

  public func saveAccessToken(_ token: String) {
    print(">saveAccessToken", token)
    UserDefaults.standard.set(token, forKey: "accessToken")
  }

  public func getAccessToken() -> String? {
    print(">getAccessToken", UserDefaults.standard.string(forKey: "accessToken"))
    return UserDefaults.standard.string(forKey: "accessToken")
  }

  public func saveRefreshToken(_ token: String) {
    print(">saveRefreshToken", token)
    UserDefaults.standard.set(token, forKey: "refreshToken")
  }

  public func getRefreshToken() -> String? {
    print(">getRefreshToken", UserDefaults.standard.string(forKey: "refreshToken"))
    return UserDefaults.standard.string(forKey: "refreshToken")
  }

  public func clearTokens() {
    UserDefaults.standard.removeObject(forKey: "accessToken")
    UserDefaults.standard.removeObject(forKey: "refreshToken")
  }
}
