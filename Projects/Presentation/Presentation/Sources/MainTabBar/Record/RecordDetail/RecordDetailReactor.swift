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
    case setDetail(RecordDetail)
    case setLoading(Bool)
    case setError(Error)
  }

  // MARK: - State
  public struct State {
    let id: Int
    fileprivate(set) var detail: RecordDetail?
    fileprivate(set) var isLoading: Bool = false
    @Pulse fileprivate(set) var error: Error?
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
      return Observable.concat([
        .just(.setLoading(true)),
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
