//
//  MyGoalSettingReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/16/25.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyGoalSettingReactor: Reactor {
  // MARK: - Action
  public enum Action {
    case initialize
    /// timeMinutes: 분(그대로 전달), distanceMeter: 미터(그대로 전달)
    case save(timeMinutes: Int?, distanceMeter: Int?)
  }

  // MARK: - Mutation
  public enum Mutation {
    case setprofileInfo(ProfileInfo)
    case setLoading(Bool)
    case setSaved(Bool)
    case setError(Error?)
  }

  // MARK: - State
  public struct State {
    fileprivate(set) var profileInfo: ProfileInfo? = nil
    fileprivate(set) var isLoading: Bool = false
    fileprivate(set) var isSaved: Bool = false
    @Pulse fileprivate(set) var error: Error?
  }

  public var initialState: State = State()

  // MARK: - Dependencies
  private let userUseCase: UserUseCase
  private let goalUseCase: GoalUseCase

  public init(userUseCase: UserUseCase, goalUseCase: GoalUseCase) {
    self.userUseCase = userUseCase
    self.goalUseCase = goalUseCase
  }

  // MARK: - Mutate
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      return fetchUserInfo()

    case let .save(timeMinutes, distanceMeter):
      return Observable.concat([
        .just(.setLoading(true)),
        saveGoal(timeMinutes: timeMinutes, distanceMeter: distanceMeter)
          .catch { .just(.setError($0)) },
        .just(.setLoading(false))
      ])
    }
  }

  // MARK: - Reduce
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setprofileInfo(profileInfo):
      newState.profileInfo = profileInfo
      newState.isSaved = false

    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      if isLoading { newState.isSaved = false }

    case let .setSaved(flag):
      newState.isSaved = flag

    case let .setError(error):
      newState.error = error
      newState.isLoading = false
      newState.isSaved = false
    }
    return newState
  }

  // MARK: - Effects
  private func fetchUserInfo() -> Observable<Mutation> {
    userUseCase
      .fetchMyUserInfo()
      .map { Mutation.setprofileInfo($0) }
      .asObservable()
  }

  /// 목표 시간(분), 목표 거리(미터) 저장. 재-fetch 없음.
  private func saveGoal(timeMinutes: Int?, distanceMeter: Int?) -> Observable<Mutation> {
    switch (timeMinutes, distanceMeter) {
    case let (.some(minutes), .some(meter)):
      return goalUseCase.saveGoalTime(time: minutes)
        .flatMap { _ in self.goalUseCase.saveGoalDistance(distance: meter) }
        .map { _ in Mutation.setSaved(true) }
        .asObservable()

    case let (.some(minutes), .none):
      return goalUseCase.saveGoalTime(time: minutes)
        .map { _ in Mutation.setSaved(true) }
        .asObservable()

    case let (.none, .some(meter)):
      return goalUseCase.saveGoalDistance(distance: meter)
        .map { _ in Mutation.setSaved(true) }
        .asObservable()

    case (.none, .none):
      return .empty()
    }
  }
}
