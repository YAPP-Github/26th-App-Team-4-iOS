//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import Domain

public final class AuthRepositoryImpl: AuthRepository {
  private let kakaoLoginService: SocialLoginService
  private let networkService: AuthNetworkService
  private let tokenStorage: AuthTokenStorage
  private let userDefaults: UserDefaults

  public init(
    kakaoLoginService: SocialLoginService,
    networkService: AuthNetworkService,
    tokenStorage: AuthTokenStorage,
    userDefaults: UserDefaults = .standard
  ) {
    self.kakaoLoginService = kakaoLoginService
    self.networkService = networkService
    self.tokenStorage = tokenStorage
    self.userDefaults = userDefaults
  }


  public func kakaoLogin(idToken: String) -> Single<LoginResult> {
    return networkService.requestKakaoLogin(idToken: idToken)
      .map { remoteLoginResult in
        let domainResult = remoteLoginResult.toDomain()
        self.tokenStorage.saveAccessToken(domainResult.tokenResponse.accessToken)
        self.tokenStorage.saveRefreshToken(domainResult.tokenResponse.refreshToken)
        self.tokenStorage.saveIdToken(idToken)
        self.userDefaults.set(SocialLoginType.kakao.rawValue, forKey: "loginType")
        return domainResult
      }
      .catch { [weak self] error in
        guard let self = self,
              let authError = error as? AuthError,
              case .tokenExpired = authError else {
          return .error(error)
        }

        return self.refreshToken()
          .flatMap { didRefresh in
            if didRefresh {
              return self.kakaoLogin(idToken: idToken)
            } else {
              return .error(authError)
            }
          }
      }
  }

  public func appleLogin(idToken: String) -> Single<LoginResult> {
    return networkService.requestAppleLogin(idToken: idToken)
      .map { remoteLoginResult in
        let domainResult = remoteLoginResult.toDomain()
        self.tokenStorage.saveAccessToken(domainResult.tokenResponse.accessToken)
        self.tokenStorage.saveRefreshToken(domainResult.tokenResponse.refreshToken)
        self.tokenStorage.saveIdToken(idToken)
        self.userDefaults.set(SocialLoginType.apple.rawValue, forKey: "loginType")
        return domainResult
      }
      .catch { [weak self] error in
        guard let self = self,
              let authError = error as? AuthError,
              case .tokenExpired = authError else {
          return .error(error)
        }

        return self.refreshToken()
          .flatMap { didRefresh in
            if didRefresh {
              return self.appleLogin(idToken: idToken)
            } else {
              return .error(authError)
            }
          }
      }
  }

  public func performKakaoSocialLogin() -> Single<String> {
    return kakaoLoginService.login()
  }

  public func attemptAutoLogin() -> Single<LoginResult> {
    guard
      let loginTypeRaw = userDefaults.string(forKey: "loginType"),
      let loginType = SocialLoginType(rawValue: loginTypeRaw),
      let idToken = tokenStorage.getIdToken()
    else {
      return .error(AuthError.invalidSession)
    }

    switch loginType {
    case .apple:
      return appleLogin(idToken: idToken)

    case .kakao:
      return kakaoLogin(idToken: idToken)
    }
  }

  private func refreshToken() -> Single<Bool> {
    guard let refreshToken = tokenStorage.getRefreshToken(), !refreshToken.isEmpty else {
      return .just(false)
    }

    return networkService.requestRefreshToken(refreshToken: refreshToken)
      .map { [weak self] remoteLoginResult in
        guard let self = self else { return false }
        self.tokenStorage.saveAccessToken(remoteLoginResult.accessToken)
        self.tokenStorage.saveRefreshToken(remoteLoginResult.refreshToken)
        return true
      }
      .catch { error in
        print("Failed to refresh token: \(error.localizedDescription)")
        return .just(false)
      }
  }
}
