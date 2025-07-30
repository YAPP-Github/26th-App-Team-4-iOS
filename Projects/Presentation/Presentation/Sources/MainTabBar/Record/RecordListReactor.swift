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
    case setRecordSummary(RecordSummary)
    case setRecords([RunningRecord])
    case setError(Error)
  }

  public struct State {
    fileprivate(set) var recordSummry: RecordSummary?
    fileprivate(set) var records: [RunningRecord] = []
    @Pulse fileprivate(set) var error: Error?
  }

  public var initialState: State = State()

  private let recordUseCase: RecordUseCase

  init(recordUseCase: RecordUseCase) {
    self.recordUseCase = recordUseCase
  }

}
