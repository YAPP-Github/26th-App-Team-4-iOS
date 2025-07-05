//
//  LoginReactor.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import ReactorKit
import RxSwift
import Domain

public final class LoginReactor: Reactor {
  // MARK: - Action
  public enum Action {
    case loginWithApple(token: String)
    case loginWithKakao(token: String)
  }

  // MARK: - Mutation
  public enum Mutation {
    case setLoading(Bool)
    case setLoginSuccess(String)
    case setLoginFailure(Error)
  }

  // MARK: - State
  public struct State {
    public var isLoading: Bool = false
    public var isLoginSuccess: Bool = false
    public var user: User?
    public var loginError: Error?
  }

  // MARK: - Properties
  public let initialState = State()

  // MARK: - Mutate
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loginWithApple(let token), .loginWithKakao(let token):
      return Observable.concat([
        .just(.setLoading(true)),

        // TODO: - 로그인 로직
      ])
    }
  }

  // MARK: - Reduce
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
      if isLoading {
        newState.isLoginSuccess = false
        newState.loginError = nil
      }

    case .setLoginSuccess(let message):
      newState.isLoginSuccess = true
      newState.loginError = nil

    case .setLoginFailure(let error):
      newState.loginError = error
      newState.isLoginSuccess = false
    }

    return newState
  }
}
