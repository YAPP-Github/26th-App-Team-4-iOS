//
//  HomeReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/19/25.
//

import Foundation
import ReactorKit
import RxSwift

import Domain


public class HomeReactor: Reactor {
  public enum Action {
    case initialize
  }

  public enum Mutation {
    case setHomeInfo(HomeInfo)
    case setError(Error)
  }

  public struct State {
    fileprivate(set) var homeInfo: HomeInfo?
    @Pulse fileprivate(set) var error: Error?
  }

  public var initialState: State = State()

  private let homeUseCase: HomeUseCase

  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return fetchHomeInfo()
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setHomeInfo(homeInfo):
      newState.homeInfo = homeInfo
    case let .setError(error):
      newState.error = error
    }
    return newState
  }

  private func fetchHomeInfo() -> Observable<Mutation> {
    return homeUseCase
      .fetchHomeData()
      .map { Mutation.setHomeInfo($0) }
      .catch { .just(.setError($0)) }
      .asObservable()
  }

}

