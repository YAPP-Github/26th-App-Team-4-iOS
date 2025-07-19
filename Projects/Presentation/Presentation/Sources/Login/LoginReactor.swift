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
    case appleLoginTapped
    case kakaoLoginCompleted(String)
    case appleLoginCompleted(String)
    case appleLoginFailed(Error)
  }

  public enum Mutation {
    case setLoginLoading(Bool)
    case setLoginResult(Bool)
    case setSocialLoginResult(LoginResult)
    case setLoginError(Error)
  }

  public struct State {
    var isLoading: Bool = false
    var isLoggedIn: Bool? = nil
    var socialLoginResult: LoginResult? = nil
    var error: Error? = nil
  }

  public let initialState = State()
  private let authUseCase: AuthUseCase

  public init(authUseCase: AuthUseCase) {
    self.authUseCase = authUseCase
  }

  // MARK: - Mutate

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .kakaoLoginTapped:
      return .empty()

    case .appleLoginTapped:
      return .empty()

    case .kakaoLoginCompleted(let idToken):
      return Observable.concat([
        .just(.setLoginLoading(true)),
        authUseCase.kakaoLogin(idToken: idToken)
          .asObservable()
          .map { Mutation.setSocialLoginResult($0) }
          .catch { error in
            print("> Kakao Login Error: \(error.localizedDescription)")
            return .just(Mutation.setLoginError(error))
          },
        .just(.setLoginLoading(false))
      ])

    case .appleLoginCompleted(let idToken):
      return Observable.concat([
        .just(.setLoginLoading(true)),
        authUseCase.appleLogin(idToken: idToken)
          .asObservable()
          .map { Mutation.setSocialLoginResult($0) }
          .catch { error in
            print("> Apple Login Completion Error: \(error.localizedDescription)")
            return .just(Mutation.setLoginError(error))
          },
        .just(.setLoginLoading(false))
      ])

    case .appleLoginFailed(let error):
      print("Apple Login Failed: \(error.localizedDescription)")
      return .concat([
        .just(.setLoginLoading(false)),
        .just(Mutation.setLoginError(error))
      ])
    }
  }

  // MARK: - Reduce

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.error = nil

    switch mutation {
    case .setLoginLoading(let isLoading):
      newState.isLoading = isLoading
    case .setLoginResult(let isSuccess):
      newState.isLoggedIn = isSuccess
    case .setSocialLoginResult(let result):
      newState.socialLoginResult = result
      newState.isLoggedIn = true
    case .setLoginError(let error):
      newState.error = error
      newState.isLoading = false
    }
    return newState
  }
}
