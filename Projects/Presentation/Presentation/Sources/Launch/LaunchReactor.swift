//
//  LaunchReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import ReactorKit
import RxSwift
import Domain

public final class LaunchReactor: Reactor {
  public enum Action {
    case checkUserStatus
  }

  public enum Mutation {
    case setLoading(Bool)
    case setUserStatusChecked(UserStatus)
    case setError(Error)
  }

  public struct State {
    var isLoading: Bool = true
    var userStatus: UserStatus?
    var error: Error?
  }

  public var initialState: State = State()

  private let checkLoginStatusUseCase: CheckLoginStatusUseCase

  public init(checkLoginStatusUseCase: CheckLoginStatusUseCase) {
    self.checkLoginStatusUseCase = checkLoginStatusUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkUserStatus:
      return Observable.concat([
        .just(.setLoading(true)),
        checkLoginStatusUseCase.execute()
          .asObservable()
          .map { Mutation.setUserStatusChecked($0) }
          .catch { error in
            return .just(Mutation.setError(error))
          },
        .just(.setLoading(false))
      ])
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .setUserStatusChecked(let status):
      newState.userStatus = status
      newState.isLoading = false
    case .setError(let error):
      newState.error = error
      newState.isLoading = false
    }
    return newState
  }
}
