//
//  LoginReactor.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import ReactorKit
import RxSwift
import Domain
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

public final class LoginReactor: Reactor {
  public enum Action {
    case kakaoLoginTapped
    case appleLoginCompleted(String)
  }

  public enum Mutation {
    case setLoading(Bool)
    case setSocialLoginResult(LoginResult)
    case setLoginError(String)
  }

  public struct State {
    var isLoading: Bool = false
    var socialLoginResult: LoginResult? = nil
    var error: String? = nil
  }

  public let initialState = State()

  private let authUseCase: AuthUseCase

  public init(authUseCase: AuthUseCase) {
    self.authUseCase = authUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .kakaoLoginTapped:
      return Observable.concat([
        .just(.setLoading(true)),
        loginWithKakao(),
        .just(.setLoading(false))
      ])

    case .appleLoginCompleted(let idToken):
      return Observable.concat([
        .just(.setLoading(true)),
        authUseCase.appleLogin(idToken: idToken)
          .asObservable()
          .map { Mutation.setSocialLoginResult($0) }
          .catch { error in
            return .just(Mutation.setLoginError(error.localizedDescription))
          },
        .just(.setLoading(false))
      ])
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.error = nil

    switch mutation {
    case .setLoading(let loading):
      newState.isLoading = loading

    case .setSocialLoginResult(let result):
      newState.socialLoginResult = result

    case .setLoginError(let error):
      newState.error = error
    }
    return newState
  }

  // MARK: - Login Logic
  private func loginWithKakao() -> Observable<Mutation> {
    return Observable<Mutation>.create { [weak self] observer in
      guard let self = self else {
        observer.onCompleted()
        return Disposables.create()
      }

      let completion: (OAuthToken?, Error?) -> Void = { token, error in
        if let error = error {
          observer.onNext(.setLoginError(error.localizedDescription))
          observer.onCompleted()
          return
        }

        guard let idToken = token?.idToken else {
          // TODO: - 에러처리
//          observer.onNext(.setLoginError())
          observer.onCompleted()
          return
        }

        self.authUseCase.kakaoLogin(idToken: idToken)
          .subscribe(
            onSuccess: { result in
              observer.onNext(.setSocialLoginResult(result))
              observer.onCompleted()
            },
            onFailure: { error in
              observer.onNext(.setLoginError(error.localizedDescription))
              observer.onCompleted()
            }
          )
          .disposed(by: self.disposeBag)
      }

      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk(completion: completion)
      } else {
        UserApi.shared.loginWithKakaoAccount(completion: completion)
      }

      return Disposables.create()
    }
  }

  private let disposeBag = DisposeBag()
}
