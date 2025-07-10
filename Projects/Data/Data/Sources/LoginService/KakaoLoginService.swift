//
//  KakaoLoginService.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser
import Domain

public protocol KakaoLoginServiceType {
  func login() -> Single<SocialLoginInfo>
}

public final class KakaoLoginService: KakaoLoginServiceType {
  public init() {}
  
  public func login() -> Single<SocialLoginInfo> {
    return Single.create { single in
      let loginHandler: (OAuthToken?, Error?) -> Void = { (oauthToken, error) in
        if let error = error {
          single(.failure(error))
        } else if let oauthToken = oauthToken {
          UserApi.shared.me { (user, error) in
            if let error = error {
              single(.failure(error))
            } else if let user = user, let id = user.id {
              let socialLoginInfo = SocialLoginInfo(
                provider: "kakao",
                token: oauthToken.accessToken,
                id: String(id),
                name: user.kakaoAccount?.profile?.nickname,
                email: user.kakaoAccount?.email,
                authorizationCode: nil
              )
              single(.success(socialLoginInfo))
            } else {
              single(.failure(NSError(domain: "KakaoLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "카카오 사용자 정보 가져오기 실패"])))
            }
          }
        } else {
          single(.failure(NSError(domain: "KakaoLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "카카오 로그인 실패"])))
        }
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
