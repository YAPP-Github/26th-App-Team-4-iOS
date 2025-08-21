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
      var initialItems: [MyRunningSettingViewController.Item: Bool] = [:]

      for item in MyRunningSettingViewController.Item.allCases {
        let isOn = UserDefaults.standard.bool(forKey: item.userDefaultsKey)
        initialItems[item] = isOn
      }
      return .just(.setItems(initialItems))

    case .toggleItem(item: let item):
      var newItems = currentState.items
      let currentValue = newItems[item] ?? false
      let newValue = !currentValue
      newItems[item] = newValue

      UserDefaults.standard.set(newValue, forKey: item.userDefaultsKey)

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
