//
//  LoginReactor.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import ReactorKit
import RxSwift

public final class LoginReactor: Reactor {
  // MARK: - Action
  public enum Action {
    case loginWithApple(token: String)
    case loginWithKakao(token: String)
  }

  // MARK: - Mutation
  public enum Mutation {
    case setLoading(Bool)
    case setLoginSuccess(String)   // success message
    case setLoginFailure(Error)    // error object
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
  private let loginUseCase: LoginUseCase

  // MARK: - Init
  public init(loginUseCase: LoginUseCase) {
    self.loginUseCase = loginUseCase
  }

  // MARK: - Mutate
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loginWithApple(let token), .loginWithKakao(let token):
      return Observable.concat([
        .just(.setLoading(true)),

        loginUseCase.login(with: token)
          .map { Mutation.setLoginSuccess("로그인 성공: \($0.name)") }
          .catch { error in .just(.setLoginFailure(error)) }
          .asObservable(),

          .just(.setLoading(false))
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
public protocol LoginUseCase {
  func login(with token: String) -> Single<User>
}

public final class DefaultLoginUseCase: LoginUseCase {
  private let repository: LoginRepository

  public init(repository: LoginRepository) {
    self.repository = repository
  }

  public func login(with token: String) -> Single<User> {
    return repository.login(with: token)
  }
}

import RxSwift
import Domain

public protocol LoginRepository {
  func login(with token: String) -> Single<User>
}


import Foundation
import RxSwift
import Moya
import RxMoya
import Domain

public final class DefaultLoginRepository: LoginRepository {
  private let provider: MoyaProvider<LoginAPI>

  public init(provider: MoyaProvider<LoginAPI> = MoyaProvider<LoginAPI>()) {
    self.provider = provider
  }

  public func login(with token: String) -> Single<User> {
    return provider.rx.request(.socialLogin(token: token))
      .filterSuccessfulStatusCodes()
      .map(UserResponse.self)
      .map { $0.result }
  }
}
