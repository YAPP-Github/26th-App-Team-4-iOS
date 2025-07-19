//
//  LoginRepository.swift
//  Domain
//
//  Created by dong eun shin on 6/27/25.
//

import Foundation
import RxSwift

public protocol AuthRepository {
  func kakaoLogin(idToken: String) -> Single<LoginResult>
  func appleLogin(idToken: String) -> Single<LoginResult>

  func performKakaoSocialLogin() -> Single<String>

  func hasValidAuthSession() -> Single<Bool>
}
