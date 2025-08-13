//
//  MyLevelSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//


import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyLevelSettingReactor: Reactor {
  
  public enum Action {
    case initialize
    case selectLevel(idx: Int)
    case save
  }
  
  public enum Mutation {
    case setLevel(Int)
    case setIsSaved(Bool)
  }
  
  public struct State {
    fileprivate(set) var level: Int = 0
    fileprivate(set) var isSaved: Bool = false
  }
  
  public var initialState: State = State()
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return .just(.setLevel(0))
      
    case let .selectLevel(idx):
      return .just(.setLevel(idx))
      
    case .save:
      return .empty()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setLevel(level):
      newState.level = level
      
    case let .setIsSaved(isSaved):
      newState.isSaved = isSaved
    }
    return newState
  }}
