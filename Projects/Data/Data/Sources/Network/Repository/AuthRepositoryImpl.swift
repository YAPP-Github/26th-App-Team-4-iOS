//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import Domain
import Moya

public struct LoginResponse: Codable {
  let accessToken: String
  let refreshToken: String
  let userId: String
  let isNewUser: Bool?
}

public struct RegisterResponse: Codable {
  let message: String
}

public final class AuthRepositoryImpl: AuthUseCaseType {
  private let networkService: NetworkServiceType
  private let tokenStorage: TokenStorageType
  private let kakaoLoginService: KakaoLoginServiceType
  private let appleLoginService: AppleLoginServiceType
  
  public init(networkService: NetworkServiceType, tokenStorage: TokenStorageType, kakaoLoginService: KakaoLoginServiceType, appleLoginService: AppleLoginServiceType) {
    self.networkService = networkService
    self.tokenStorage = tokenStorage
    self.kakaoLoginService = kakaoLoginService
    self.appleLoginService = appleLoginService
  }
  
  public func kakaoLogin() -> Single<SocialLoginResult> {
    return kakaoLoginService.login()
      .flatMap { [weak self] socialLoginInfo -> Single<SocialLoginResult> in
        guard let self = self else { return .error(NSError(domain: "AuthRepositoryImpl", code: -1, userInfo: nil)) }
        return self.networkService.request(AuthAPI.socialLogin(info: socialLoginInfo), responseType: LoginResponse.self)
          .do(onNext: { [weak self] response in
            self?.tokenStorage.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
          })
          .map { SocialLoginResult(accessToken: $0.accessToken, refreshToken: $0.refreshToken, isNewUser: $0.isNewUser ?? false) }
          .asSingle()
      }
  }
  
  public func appleLogin(identityToken: String, authCode: String?, email: String?, fullName: String?, userIdentifier: String) -> Single<SocialLoginResult> {
    let socialLoginInfo = SocialLoginInfo(
      provider: "apple",
      token: identityToken,
      id: userIdentifier,
      name: fullName,
      email: email,
      authorizationCode: authCode
    )
    
    return networkService.request(AuthAPI.socialLogin(info: socialLoginInfo), responseType: LoginResponse.self)
      .do(onNext: { [weak self] response in
        self?.tokenStorage.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
      })
      .map { SocialLoginResult(accessToken: $0.accessToken, refreshToken: $0.refreshToken, isNewUser: $0.isNewUser ?? false) }
      .asSingle()
  }
}
