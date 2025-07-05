//
//  WalkthroughReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import Foundation

import ReactorKit
import RxSwift

public final class WalkthroughReactor: Reactor {
  public enum Action {
    case completeWalkthrough
  }
  
  public enum Mutation {
    case setComplete(Bool)
  }
  
  public struct State {
    var didComplete: Bool = false
  }
  
  public var initialState: State = State()
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .completeWalkthrough:
      return .just(Mutation.setComplete(true))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setComplete(let complete):
      newState.didComplete = complete
    }
    return newState
  }
}
