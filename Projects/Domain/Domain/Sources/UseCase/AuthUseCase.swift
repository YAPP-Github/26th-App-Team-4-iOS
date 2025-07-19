//
//  AuthUseCase.swift
//  Domain
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import AuthenticationServices
import RxSwift

public protocol AuthUseCase {
  func kakaoLogin() -> Single<LoginResult>
  func appleLogin(idToken: String) -> Single<LoginResult>
}

public final class AuthUseCaseImpl: AuthUseCase {
  private let authRepository: AuthRepository

  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  public func kakaoLogin() -> Single<LoginResult> {
    return authRepository.performKakaoSocialLogin()
      .flatMap { idToken in
        self.authRepository.kakaoLogin(idToken: idToken)
      }
  }

  public func appleLogin(idToken: String) -> Single<LoginResult> {
    return authRepository.appleLogin(idToken: idToken)
  }
}
