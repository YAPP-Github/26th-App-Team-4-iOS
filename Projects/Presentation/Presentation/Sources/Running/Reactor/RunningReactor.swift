//
//  RunningReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/23/25.
//

import UIKit
import CoreLocation
import Domain
import ReactorKit
import RxSwift

public final class RunningReactor: Reactor {
  public enum Action {
    case startTimer
    case togglePaused
    case tick
    case stopRun
    case updateLocation(CLLocation)
    case uploadSnapshot(UIImage)
  }

  public enum Mutation {
    case setPaused(Bool)
    case incrementTime
    case addLocation(CLLocationCoordinate2D)
    case setRunFinished
    case setUploadSuccess(Bool)
  }

  public struct State {
    var isPaused: Bool = false
    var elapsedTime: TimeInterval = 0
    var runningPath: [CLLocationCoordinate2D] = []
    var isRunFinished: Bool = false
    var isUploadSuccess: Bool = false
  }

  public let initialState = State()
  private let runningRecordUseCase: RunningRecordUseCase
  private var timer: Timer?

  public init(runningRecordUseCase: RunningRecordUseCase) {
    self.runningRecordUseCase = runningRecordUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .startTimer:
      startTimer()
      return .empty()

    case .togglePaused:
      return .just(.setPaused(!currentState.isPaused))

    case .tick:
      guard !currentState.isPaused else { return .empty() }
      return .just(.incrementTime)

    case .updateLocation(let location):
      guard !currentState.isPaused else { return .empty() }
      let coordinate = location.coordinate
      return .just(.addLocation(coordinate))

    case .stopRun:
      timer?.invalidate()
      return .just(.setRunFinished)

    case .uploadSnapshot(let image):
      return runningRecordUseCase.saveRunningRecord(recordId: "", path: currentState.runningPath, image: image)
        .asObservable()
        .map { .setUploadSuccess($0) }
    }
  }

  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.action.onNext(.tick)
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setPaused(paused):
      newState.isPaused = paused

    case .incrementTime:
      newState.elapsedTime += 1

    case .addLocation(let coordinate):
      newState.runningPath.append(coordinate)

    case .setRunFinished:
      newState.isRunFinished = true

    case .setUploadSuccess(let success):
      newState.isUploadSuccess = success
    }
    return newState
  }
}
