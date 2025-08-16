//
//  RunnerTypeViewReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/17/25.
//

import ReactorKit
import RxSwift
import Domain

public final class RunnerTypeViewReactor: Reactor {
  public enum Action {
    case initialize
  }
  
  public enum Mutation {
    case setType(RunnerType)
  }
  
  public struct State {
    /// 질문 단계
    public fileprivate(set) var type: RunnerType?
  }
  
  public var initialState: State = State()
  
  private let userUseCase: UserUseCase
  
  init(userUseCase: UserUseCase) {
    self.userUseCase = userUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    print("\(type(of: self)) - \(#function)", action)
    
    switch action {
    case .initialize:
      return fetchUserInfo()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setType(type):
      newState.type = type
    }
    return newState
  }
  
  private func fetchUserInfo() -> Observable<Mutation> {
    print("\(type(of: self)) - \(#function)")
    return userUseCase.fetchMyUserInfo()
      .map { userInfo in
        return .setType(userInfo.goal.runnerType)
      }
      .asObservable()
  }
}
