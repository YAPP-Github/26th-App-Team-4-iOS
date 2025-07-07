//
//  MainTabBarReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/5/25.
//

import ReactorKit
import Foundation

final class MainTabBarReactor: Reactor {

  // MARK: - Tab enum
  enum Tab: Int {
    case home
    case running
    case profile
  }

  // MARK: - Action
  enum Action {
    case selectTab(Int)
  }

  // MARK: - Mutation
  enum Mutation {
    case setSelectedTab(Tab)
  }

  // MARK: - State
  struct State {
    var selectedTab: Tab = .home
  }

  let initialState: State = State()

  // MARK: - Mutate
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectTab(let index):
      guard let tab = Tab(rawValue: index) else { return .empty() }
      return .just(.setSelectedTab(tab))
    }
  }

  // MARK: - Reduce
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setSelectedTab(let tab):
      newState.selectedTab = tab
    }
    return newState
  }
}
