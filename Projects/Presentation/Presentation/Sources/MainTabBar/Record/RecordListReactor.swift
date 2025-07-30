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
  
  public enum Action {
    case initialize
  }

  public enum Mutation {
    case
    case setError(Error)
  }

  public struct State {
    fileprivate(set) var recordOverViewData: HomeInfo?
    @Pulse fileprivate(set) var error: Error?
  }

  public var initialState: State = State()

  private let homeUseCase: HomeUseCase

  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }

}
