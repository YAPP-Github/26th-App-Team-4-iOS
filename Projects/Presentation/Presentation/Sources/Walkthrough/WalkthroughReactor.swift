//
//  WalkThroughReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/9/25.
//

import ReactorKit
import Foundation
import RxSwift

public final class WalkThroughReactor: Reactor {

  // MARK: – Constants
  private let totalPageCount = WalkThroughStep.allCases.count

  // MARK: – Actions
  public enum Action {
    case scrollToPage(Int)
    case moveToNextPage
  }

  // MARK: – Mutations
  public enum Mutation {
    case setCurrentPage(Int)
    case setShouldShowStart(Bool)
  }

  // MARK: – State
  public struct State {
    fileprivate(set) var currentPage: Int = 0
    @Pulse fileprivate(set) var shouldShowStart: Bool = false
  }

  // MARK: – Initial State
  public let initialState = State()

  // MARK: – Mutate
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    case let .scrollToPage(index):
      // 스크롤로 페이지 바꿀 때도 마지막 페이지인지 체크
      let isLast = (index == totalPageCount - 1)
      return Observable.concat([
        .just(.setCurrentPage(index)),
        .just(.setShouldShowStart(isLast))
      ])

    case .moveToNextPage:
      // 다음 버튼 탭 시
      let nextIndex = min(currentState.currentPage + 1, totalPageCount - 1)
      let isLast = (nextIndex == totalPageCount - 1)
      return Observable.concat([
        .just(.setCurrentPage(nextIndex)),
        .just(.setShouldShowStart(isLast))
      ])
    }
  }

  // MARK: – Reduce
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setCurrentPage(page):
      newState.currentPage = page

    case let .setShouldShowStart(flag):
      newState.shouldShowStart = flag
    }
    return newState
  }
}

