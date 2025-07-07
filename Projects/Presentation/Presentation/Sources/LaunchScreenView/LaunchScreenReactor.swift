//
//  LaunchScreenReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/7/25.
//

import ReactorKit

final class LaunchScreenReactor: Reactor {
  
  /// 런치 스크린 다음 화면 정의
  enum NextScene {
    case onboarding
  }
  
  // MARK: - Actions
  enum Action {
    case initialize
  }
  
  // MARK: - Mutations
  enum Mutation {
    case setError(Error)
    case setNextScene(NextScene)
  }
  
  // MARK: - State
  struct State {
    @Pulse fileprivate(set) var error: Error?
    fileprivate(set) var nextScene: NextScene?
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return initialize()
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    print("\(type(of: self)) - \(#function)", mutation)
    
    var newState = state
    switch mutation {
    case let .setNextScene(nextScene):
      newState.nextScene = nextScene
    case let .setError(error):
      newState.error = error
    }
    return newState
  }
  
  private func initialize() -> Observable<Mutation> {
    return .just(.setNextScene(.onboarding))
  }
}
