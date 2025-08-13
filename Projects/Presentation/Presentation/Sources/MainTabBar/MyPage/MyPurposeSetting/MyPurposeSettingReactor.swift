//
//  MyPurposeSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//


import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyPurposeSettingReactor: Reactor {
  
  public enum Action {
    case initialize
    case selectPurpose(idx: Int)
    case save
  }
  
  public enum Mutation {
    case setPaceSecond(Int)
    case setIsSaved(Bool)
  }
  
  public struct State {
    fileprivate(set) var purpose: Int = 0
    fileprivate(set) var isSaved: Bool = false
  }
  
  public var initialState: State = State()
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return .empty()
    case let .selectPurpose(idx):
      return .just(.setPaceSecond(idx))
    case .save:
      return .empty()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setPaceSecond(paceSecond):
      newState.purpose = paceSecond
    case let .setIsSaved(isSaved):
      newState.isSaved = isSaved
    }
    return newState
  }
}
