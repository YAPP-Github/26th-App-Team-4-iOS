//
//  KakaoLoginServiceImpl.swift
//  Data
//
//  Created by dong eun shin on 7/19/25.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

public protocol SocialLoginService {
  func login() -> Single<String>
}

public final class KakaoLoginServiceImpl: SocialLoginService {

  public init() {}

  public func login() -> Single<String> {
    return Single.create { single in
      let loginHandler: (OAuthToken?, Error?) -> Void = { (oauthToken, error) in
        if let error = error {
          single(.failure(SocialLoginError.authenticationFailed(error)))
        }

        guard let idToken = oauthToken?.idToken else {
          return single(.failure(SocialLoginError.idTokenNotFound))
        }

        single(.success(idToken))
      }

      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk(completion: loginHandler)
      } else {
        UserApi.shared.loginWithKakaoAccount(completion: loginHandler)
      }
      return Disposables.create()
    }
  }
}
