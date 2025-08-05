//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import Domain

public final class AuthRepositoryImpl: AuthRepository {
  private let kakaoLoginService: SocialLoginService
  private let networkService: AuthNetworkService
  private let tokenStorage: AuthTokenStorage

  public init(kakaoLoginService: SocialLoginService, networkService: AuthNetworkService, tokenStorage: AuthTokenStorage) {
    self.kakaoLoginService = kakaoLoginService
    self.networkService = networkService
    self.tokenStorage = tokenStorage
  }

  public func kakaoLogin(idToken: String) -> Single<LoginResult> {
    return networkService.requestKakaoLogin(idToken: idToken)
      .map { remoteLoginResult in
        let domainResult = remoteLoginResult.toDomain()
        print(">>>domainResult", domainResult)
        self.tokenStorage.saveAccessToken(domainResult.tokenResponse.accessToken)
        self.tokenStorage.saveRefreshToken(domainResult.tokenResponse.refreshToken)
        return domainResult
      }
  }

  public func appleLogin(idToken: String) -> Single<LoginResult> {
    return networkService.requestAppleLogin(idToken: idToken)
      .map { remoteLoginResult in
        let domainResult = remoteLoginResult.toDomain()
        self.tokenStorage.saveAccessToken(domainResult.tokenResponse.accessToken)
        self.tokenStorage.saveRefreshToken(domainResult.tokenResponse.refreshToken)
        return domainResult
      }
  }

  public func performKakaoSocialLogin() -> Single<String> {
    return kakaoLoginService.login()
  }

  public func hasValidAuthSession() -> Single<Bool> {
    if let accessToken = tokenStorage.getAccessToken(), !accessToken.isEmpty {
      return .just(true)
    }

    return refreshToken()
      .map { didRefresh in
        return didRefresh
      }
      .catchAndReturn(false)
  }

  public func refreshToken() -> Single<Bool> {
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
