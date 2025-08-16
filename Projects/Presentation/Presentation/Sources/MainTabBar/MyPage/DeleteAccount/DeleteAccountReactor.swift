//
//  DeleteAccountReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/16/25.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public final class DeleteAccountReactor: Reactor {
  
  public enum Action {
    case initialize
    case deleteAccount(reason: String)
  }
  
  public enum Mutation {
    case setAccountDeleted(Bool)
  }
  
  public struct State {
    fileprivate(set) var accountDeleted: Bool = false
  }
  
  public var initialState: State = State()
  
  private let userUseCase: UserUseCase
  
  init(userUseCase: UserUseCase) {
    self.userUseCase = userUseCase
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    print("\(type(of: self)) - \(#function)", action)

    switch action {
    case .initialize:
      return .empty()
    case let .deleteAccount(reason):
      return deleteAccount(reason: reason)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setAccountDeleted(accountDeleted):
      newState.accountDeleted = accountDeleted
    }
    return newState
  }
  
  private func deleteAccount(reason: String) -> Observable<Mutation> {
    print("\(type(of: self)) - \(#function)")
    return userUseCase
      .deleteAccount(reason: reason)
      .map { _ in Mutation.setAccountDeleted(true) }
      .asObservable()
  }
}
