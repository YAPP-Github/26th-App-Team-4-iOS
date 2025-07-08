//
//  WalkThroughReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/8/25.
//

import ReactorKit


public final class WalkThroughReactor: Reactor {
  
  /// 런치 스크린 다음 화면 정의
  public enum NextScene {
    case onboarding
  }
  
  // MARK: - Actions
  public enum Action {
    case initialize
  }
  
  // MARK: - Mutations
  public enum Mutation {
    case setError(Error)
    case setNextScene(NextScene)
  }
  
  // MARK: - State
  public struct State {
    @Pulse fileprivate(set) var error: Error?
    fileprivate(set) var nextScene: NextScene?
  }
  
  public var initialState: State = State()
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return .empty()
    }
  }
  
}
