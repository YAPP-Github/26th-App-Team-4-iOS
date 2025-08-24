//
//  RecordDetailReactor.swift
//  Presentation
//
//  Created by JDeoks on 7/31/25.
//

import Foundation
import ReactorKit
import RxSwift
import NMapsMap

import Domain

public class RecordDetailReactor: Reactor {

  // MARK: - Action
  public enum Action {
    case initialize
    case mapRendered(_ mapViewImage: UIImage)
    case deleteRecord
  }

  // MARK: - Mutation
  public enum Mutation {
    case setDetail(RunningRecord?)
    case setLoading(Bool)
    case setError(Error)
    case setShouldShowFirstRunningPopUp(Bool)
    case setDeleted(Bool)
  }

  // MARK: - State
  public struct State {
    let id: Int
    fileprivate(set) var detail: RunningRecord?
    fileprivate(set) var isLoading: Bool = false
    @Pulse fileprivate(set) var error: Error?
    fileprivate(set) var shouldShowFirstRunningPopUp: Bool = false
    fileprivate(set) var isDeleted: Bool = false
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

    case let .mapRendered(mapViewImage):
      guard let record = currentState.detail else { return .empty() }

      return runningRecordImageUseCase.uploadImage(mapViewImage, recordId: record.recordId)
        .asObservable()
        .flatMap { newImageUrl -> Observable<Mutation> in
          guard let newImageUrl = newImageUrl else {
            return .just(.setError(NSError(domain: "ImageUploadError", code: 0, userInfo: nil)))
          }
          var updatedRecord = record
          updatedRecord.imageUrl = newImageUrl
          return .just(.setDetail(updatedRecord))
        }
        .catch { error in
          Observable.just(Mutation.setError(error))
        }

    case .deleteRecord:
      guard let recordId = currentState.detail?.recordId else { return .empty() }
      return recordUseCase.deleteRecord(recordId: recordId)
        .asObservable()
        .flatMap { success -> Observable<Mutation> in
          return .just(.setDeleted(success))
        }
        .catch { Observable.just(Mutation.setError($0)) }
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

    case let .setDeleted(isDeleted):
      newState.isDeleted = isDeleted
    }
    return newState
  }

  private func fetchDetail() -> Observable<Mutation> {
    let id = initialState.id
    return recordUseCase.fetchRecordDetial(id: id)
      .asObservable()
      .flatMap { record -> Observable<Mutation> in
        return .just(.setDetail(record))
      }
      .catch { Observable.just(Mutation.setError($0)) }
  }

  private func uploadMapViewImage(_ mapViewImage: UIImage) -> Observable<Mutation> {
    guard let record = currentState.detail else { return .empty() }

    return runningRecordImageUseCase.uploadImage(mapViewImage, recordId: record.recordId)
      .asObservable()
      .flatMap { newImageUrl -> Observable<Mutation> in
        guard let newImageUrl = newImageUrl else {
          return .just(.setError(NSError(domain: "ImageUploadError", code: 0, userInfo: nil)))
        }
        var updatedRecord = record
        updatedRecord.imageUrl = newImageUrl
        return .just(.setDetail(updatedRecord))
      }
      .catch { error in
        Observable.just(Mutation.setError(error))
      }
  }
}
