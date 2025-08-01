//
//  RunningReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/23/25.
//

import ReactorKit
import Foundation
import RxSwift

public final class RunningReactor: Reactor {
  public enum Action {
    case startTimer
    case togglePaused
    case tick
  }

  public enum Mutation {
    case setPaused(Bool)
    case incrementTime
  }

  public struct State {
    var isPaused: Bool = false
    var elapsedTime: TimeInterval = 0
  }

  public let initialState = State()

  private var timer: Timer?

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .startTimer:
      startTimer()
      return .empty()

    case .togglePaused:
      return .just(.setPaused(!currentState.isPaused))

    case .tick:
      guard !currentState.isPaused else { return .empty() }
      return .just(.incrementTime)
    }
  }

  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.action.onNext(.tick)
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setPaused(paused):
      newState.isPaused = paused

    case .incrementTime:
      newState.elapsedTime += 1

    }
    return newState
  }
}
