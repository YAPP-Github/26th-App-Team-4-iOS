//
//  LoginReactor.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import ReactorKit
import RxSwift
import Domain
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
    var socialLoginResult: LoginResult?
    var error: String?
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
        authUseCase.kakaoLogin()
          .asObservable()
          .map { Mutation.setSocialLoginResult($0) }
          .catch { error in
            return .just(Mutation.setLoginError(error.localizedDescription))
          },
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
}
