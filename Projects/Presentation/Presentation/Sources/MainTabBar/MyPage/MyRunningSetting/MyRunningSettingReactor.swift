//
//  MyRunningSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyRunningSettingReactor: Reactor {
  
  public enum Action {
    case initialize
    case toggleItem(item: MyRunningSettingViewController.Item)
  }
  
  public enum Mutation {
    case setItems([MyRunningSettingViewController.Item: Bool])
  }
  
  public struct State {
    fileprivate(set) var items: [MyRunningSettingViewController.Item: Bool] = [:]
  }
  
  public var initialState: State = State()
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return .empty()
      
    case .toggleItem(item: let item):
      var newItems = currentState.items
      if let currentValue = newItems[item] {
        newItems[item] = !currentValue
      } else {
        newItems[item] = true
      }
      return .just(.setItems(newItems))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setItems(items):
      newState.items = items
    }
    return newState
  }
}
