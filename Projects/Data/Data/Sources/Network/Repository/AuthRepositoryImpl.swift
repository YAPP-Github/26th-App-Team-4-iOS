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
  private let networkService: AuthNetworkServiceType
  private let tokenStorage: AuthTokenStorageType
  
  public init(networkService: AuthNetworkServiceType, tokenStorage: AuthTokenStorageType) {
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
}
