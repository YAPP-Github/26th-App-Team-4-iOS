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
    guard let accessToken = tokenStorage.getAccessToken(), !accessToken.isEmpty else {
      return .just(false)
    }

    return .just(true)
  }
}
