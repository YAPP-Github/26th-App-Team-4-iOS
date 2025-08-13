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
    case fetchMapImage(record: RunningRecord)
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
  private let runningRecordImageUseCase: RunningRecordImageUseCase

  public init(id: Int, recordUseCase: RecordUseCase, runningRecordImageUseCase: RunningRecordImageUseCase) {
    initialState = State(id: id)
    self.recordUseCase = recordUseCase
    self.runningRecordImageUseCase = runningRecordImageUseCase
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

    case .fetchMapImage(let record):
      return runningRecordImageUseCase.generateMapImage(for: record)
        .flatMap { image in
          print("image>>>>>", image)
          return self.runningRecordImageUseCase.uploadImage(image, recordId: record.recordId)
        }
        .asObservable()
        .flatMap { newImageUrl -> Observable<Mutation> in
          guard let newImageUrl = newImageUrl else {
            return .just(.setError(NSError(domain: "ImageUploadError", code: 0, userInfo: nil)))
          }
          print("newImageUrl>>>>>", newImageUrl)

          var updatedRecord = record
          updatedRecord.imageUrl = newImageUrl
          return .just(.setDetail(updatedRecord))
        }
        .catch { error in
          Observable.just(Mutation.setError(error))
        }
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
      .flatMap { record -> Observable<Mutation> in
        guard let record = record else {
          return .just(.setDetail(nil))
        }

        let imageUrl = record.imageUrl ?? ""
        if imageUrl == "" {
          return Observable.concat([
            .just(.setDetail(record)),
            .just(.setLoading(true)),
            self.mutate(action: .fetchMapImage(record: record)),
            .just(.setLoading(false))
          ])
        } else {
          return .just(.setDetail(record))
        }
      }
      .catch { Observable.just(Mutation.setError($0)) }
  }
}
