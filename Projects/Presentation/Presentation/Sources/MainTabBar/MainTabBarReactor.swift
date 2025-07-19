//
//  MainTabBarReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/5/25.
//

import ReactorKit
import Foundation

public final class MainTabBarReactor: Reactor {

  // MARK: - Tab enum
  public enum Tab: Int {
    case home
    case running
    case profile
  }

  // MARK: - Action
  public enum Action {
    case selectTab(Int)
  }

  // MARK: - Mutation
  public enum Mutation {
    case setSelectedTab(Tab)
  }

  // MARK: - State
  public struct State {
    var selectedTab: Tab = .home
  }

  public let initialState: State = State()

  // MARK: - Mutate
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectTab(let index):
      guard let tab = Tab(rawValue: index) else { return .empty() }
      return .just(.setSelectedTab(tab))
    }
  }

  // MARK: - Reduce
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setSelectedTab(let tab):
      newState.selectedTab = tab
    }
    return newState
  }
}
