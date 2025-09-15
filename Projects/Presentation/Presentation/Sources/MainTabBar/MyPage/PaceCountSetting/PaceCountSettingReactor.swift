//
//  PaceCountSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/19/25.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public final class PaceCountSettingReactor: Reactor {
  
  public enum Action {
    case initialize
    /// 페이스 저장 요청
    case savePace(paceSecond: Int)
    /// 러닝 횟수 저장 요청
    case saveRunningCount(runningCount: Int)
  }
  
  public enum Mutation {
    case setIsSaved(Bool)
    case setPaceSecond(Int)
    case setRunningCount(Int)
  }
  
  public struct State {
    @Pulse public fileprivate(set) var isSaved: Bool = false
    public fileprivate(set) var paceSecond: Int = 0
    public fileprivate(set) var runningCount: Int = 0
  }
  
  public var initialState: State = State()
  private let goalUseCase: GoalUseCase
  
  public init(goalUseCase: GoalUseCase) {
    self.goalUseCase = goalUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    case .initialize:
      return fetchGoal()
      
    case let .savePace(paceSecond):
      return savePace(paceSecond: paceSecond)
      
    case let .saveRunningCount(runningCount):
      return saveRunningCount(runningCount: runningCount)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setIsSaved(isSaved):
      newState.isSaved = isSaved
      
    case let .setPaceSecond(paceSecond):
      newState.paceSecond = paceSecond
      
    case let .setRunningCount(runningCount):
      newState.runningCount = runningCount
    }
    return newState
  }
  
  // MARK: - Private
  
  private func fetchGoal() -> Observable<Mutation> {
    return goalUseCase.fetchRunningGoal()
      .asObservable()
      .flatMap { goal in
        Observable.concat([
          .just(.setPaceSecond(goal.paceGoal ?? 0)),
          .just(.setRunningCount(goal.weeklyRunningCount ?? 3))
        ])
      }
      .catch { error in
        Observable.concat([
          .just(.setPaceSecond(0)),
          .just(.setRunningCount(0))
        ])
      }
  }
  
  private func savePace(paceSecond: Int) -> Observable<Mutation> {
    return goalUseCase.savePace(second: paceSecond)
      .map { _ in Mutation.setIsSaved(true) }
      .catch { _ in .just(.setIsSaved(false)) }
      .asObservable()
  }
  
  private func saveRunningCount(runningCount: Int) -> Observable<Mutation> {
    return goalUseCase.saveRunningCount(count: runningCount)
      .map { _ in .setIsSaved(true) }
      .catch { _ in .just(.setIsSaved(false)) }
      .asObservable()
  }
}
