//
//  RecordListReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/31/25.
//


import Foundation
import ReactorKit
import RxSwift

import Domain

public class RecordListReactor: Reactor {
  
  // MARK: - Action
  public enum Action {
    case initialize
    case refresh
    case loadMore
  }

  // MARK: - Mutation
  public enum Mutation {
    case setSummary(RecordList)
    case setRecords([RecordEntity])
    case appendRecords([RecordEntity])
    case setLoading(Bool)
    case setHasNextPage(Bool)
    case setError(Error)
  }

  // MARK: - State
  public struct State {
    fileprivate(set) var summary: RecordList?
    fileprivate(set) var records: [RecordEntity] = []
    fileprivate(set) var isLoading: Bool = false
    fileprivate(set) var hasNextPage: Bool = true
    @Pulse fileprivate(set) var error: Error?
  }

  public var initialState = State()

  private var currentPage = 0
  private let pageSize = 10

  private let recordUseCase: RecordUseCase

  public init(recordUseCase: RecordUseCase) {
    self.recordUseCase = recordUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize, .refresh:
      resetPagination()
      return Observable.concat([
        .just(.setLoading(true)),
        .just(.setHasNextPage(true)),
        load(page: 0),
        .just(.setLoading(false))
      ])

    case .loadMore:
      guard !currentState.isLoading, currentState.hasNextPage else {
        return .empty()
      }
      return Observable.concat([
        .just(.setLoading(true)),
        load(page: currentPage + 1),
        .just(.setLoading(false))
      ])
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSummary(summary):
      newState.summary = summary

    case let .setRecords(records):
      newState.records = records

    case let .appendRecords(records):
      newState.records.append(contentsOf: records)

    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setHasNextPage(hasNextPage):
      newState.hasNextPage = hasNextPage

    case let .setError(error):
      newState.error = error
    }
    return newState
  }

  private func resetPagination() {
    currentPage = 0
    // 직접 할당하는 대신, Mutation을 통해 상태를 변경하도록 수정
    // currentState.hasNextPage = true // 이 줄을 삭제
  }

  private func load(page: Int) -> Observable<Mutation> {
    return recordUseCase
      .fetchRecordData(page: page, size: pageSize)
      .asObservable()
      .flatMap { response -> Observable<Mutation> in
        guard let response = response else { return Observable.empty() }
        let summary = response
        let records = response.records

        self.currentPage = page
        let hasNextPage = records.count == self.pageSize

        if page == 0 {
          return Observable.from([
            .setSummary(summary),
            .setRecords(records),
            .setHasNextPage(hasNextPage)
          ])
        } else {
          return Observable.from([
            .appendRecords(records),
            .setHasNextPage(hasNextPage)
          ])
        }
      }
      .catch { error in
          .just(.setError(error))
      }
  }
}
