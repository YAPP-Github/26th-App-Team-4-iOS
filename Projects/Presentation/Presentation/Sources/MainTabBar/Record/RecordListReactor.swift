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
    case setSummary(RecordSummary)
    case setRecords([RunningRecord])
    case appendRecords([RunningRecord])
    case setLoading(Bool)
    case setError(Error)
  }

  // MARK: - State
  public struct State {
    fileprivate(set) var summary: RecordSummary?
    fileprivate(set) var records: [RunningRecord] = []
    fileprivate(set) var isLoading: Bool = false
    @Pulse fileprivate(set) var error: Error?
  }

  public var initialState = State()

  private var currentPage = 0
  private let pageSize = 20
  private var hasNextPage = true

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
        load(page: 0),
        .just(.setLoading(false))
      ])

    case .loadMore:
      // 로딩 중이거나 더 불러올 게 없으면 무시
      guard !currentState.isLoading, hasNextPage else {
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
      
    case let .setError(error):
      newState.error = error
    }
    return newState
  }
  
  private func resetPagination() {
    currentPage = 0
    hasNextPage = true
  }
  
  private func load(page: Int) -> Observable<Mutation> {
    return recordUseCase
      .fetchRecordData(page: page, size: pageSize)
      .asObservable()                      // ← 여기서 Single → Observable 으로 바꿔주고
      .flatMap { response -> Observable<Mutation> in
        let summary = response.summary
        let records = response.records

        // 페이지 업데이트
        self.currentPage = page
        self.hasNextPage = records.count == self.pageSize

        if page == 0 {
          // 첫 페이지만 summary + records 두 개의 Mutation을 방출
          return Observable.from([
            .setSummary(summary),
            .setRecords(records)
          ])
        } else {
          // 그 외에는 append 하나만
          return .just(.appendRecords(records))
        }
      }
      .catch { error in
        .just(.setError(error))
      }

  }
}
