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
  
  public init() {}
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkUserStatus:
      return Observable.concat([
        // TODO: - 실제로 확인하는 로직 추가
        Observable.just(Mutation.setUserStatusChecked(.needsWalkthrough))
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
