//
//  RecordDetailReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/31/25.
//


import Foundation
import ReactorKit
import RxSwift

import Domain

public class RecordDetailReactor: Reactor {

  // MARK: - Action
  public enum Action {
    case initialize
  }

  // MARK: - Mutation
  public enum Mutation {
    case setDetail(RunningRecord?)
    case setLoading(Bool)
    case setError(Error)
    case setShouldShowFirstRunningPopUp(Bool)
  }

  // MARK: - State
  public struct State {
    let id: Int
    fileprivate(set) var detail: RunningRecord?
    fileprivate(set) var isLoading: Bool = false
    @Pulse fileprivate(set) var error: Error?
    fileprivate(set) var shouldShowFirstRunningPopUp: Bool = false
  }

  public var initialState: State

  private let recordUseCase: RecordUseCase

  public init(id: Int, recordUseCase: RecordUseCase) {
    initialState = State(id: id)
    self.recordUseCase = recordUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      let hasShownFirstRunPopUp = UserDefaults.standard.bool(forKey: "hasShownFirstRunPopUp")

      return Observable.concat([
        .just(.setLoading(true)),
        .just(.setShouldShowFirstRunningPopUp(!hasShownFirstRunPopUp)),
        fetchDetail(),
        .just(.setLoading(false))
      ])
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setDetail(detail):
      newState.detail = detail

    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setError(error):
      newState.error = error

    case let .setShouldShowFirstRunningPopUp(shouldShow):
      newState.shouldShowFirstRunningPopUp = shouldShow
    }
    return newState
  }

  private func fetchDetail() -> Observable<Mutation> {
    let id = initialState.id
    return recordUseCase.fetchRecordDetial(id: id)
      .asObservable()
      .map {
        Mutation.setDetail($0)
      }
      .catch {
        Observable.just(Mutation.setError($0))
      }
  }
}
