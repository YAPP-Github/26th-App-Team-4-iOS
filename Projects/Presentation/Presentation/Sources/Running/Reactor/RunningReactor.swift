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
  public enum SessionState {
    case idle // 초기 상태
    case starting // API 호출 중
    case inProgress // 달리기 시작
    case paused // 일시 정지
    case finished // 종료
    case uploading // 업로드 중
    case error
  }

  public enum Action {
    case startRun(startLocation: CLLocation?)
    case togglePaused
    case tick
    case stopRun
    case updateLocation(CLLocation)
    case uploadComplete
  }

  public enum Mutation {
    case setPaused(Bool)
    case incrementTime
    case addRunningPoint(RunningPoint)
    case setSessionState(SessionState)
    case setUploadSuccess(Bool)
    case setStartRunInfo(recordId: Int, serverStartTime: Date, localStartTime: Date)
    case setRunData(totalTime: TimeInterval, totalDistance: Double, averagePace: TimeInterval)
    case updateTotalDistance(Double)
  }

  public struct State {
    var isPaused: Bool = false
    var elapsedTime: TimeInterval = 0
    var runningPoints: [RunningPoint] = []
    var sessionState: SessionState = .idle
    var isUploadSuccess: Bool = false

    var recordId: String?
    var totalTime: TimeInterval = 0
    var totalDistance: Double = 0
    var totalCalories: Int = 0
    var averagePace: TimeInterval = 0
    var localStartTime: Date?
    var serverStartTime: Date?

    var runningPath: [CLLocationCoordinate2D] = []
  }

  public let initialState = State()
  private let runningStartUseCase: RunningStartUseCaseType
  private let runningCompletionUseCase: RunningCompletionUseCaseType
  private var timer: Timer?

  public init(runningStartUseCase: RunningStartUseCaseType, runningCompletionUseCase: RunningCompletionUseCaseType) {
    self.runningStartUseCase = runningStartUseCase
    self.runningCompletionUseCase = runningCompletionUseCase
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .startRun(startLocation):
      let localStartTime = Date()
      guard let location = startLocation else {
        print("Initial location not available. Starting without API call.")
        self.startTimer()
        return .concat([
          .just(.setStartRunInfo(recordId: 0, serverStartTime: localStartTime, localStartTime: localStartTime)),
          .just(.setSessionState(.inProgress))
        ])
      }

      return .concat([
        .just(.setSessionState(.starting)),
        runningStartUseCase.execute(startLocation: location, timeStamp: localStartTime)
          .asObservable()
          .flatMap { recordId -> Observable<Mutation> in
            guard let recordId = recordId else {
              print("Error: Failed to get recordId.>>>>> \(recordId)")
              return .just(.setSessionState(.finished))
            }
            self.startTimer()
            let runningPoint = RunningPoint(coordinate: location.coordinate, timestamp: localStartTime)
            return .concat([
              .just(.addRunningPoint(runningPoint)),
              .just(.setStartRunInfo(recordId: recordId, serverStartTime: localStartTime, localStartTime: localStartTime)),
              .just(.setSessionState(.inProgress))
            ])
          }
          .catch { error -> Observable<Mutation> in
            print("Error: Failed to start run. \(error.localizedDescription)")
            return .just(.setSessionState(.finished))
          }
      ])

    case .togglePaused:
      let nextState: SessionState = currentState.isPaused ? .inProgress : .paused
      return .just(.setSessionState(nextState))

    case .tick:
      guard !currentState.isPaused else { return .empty() }
      return .just(.incrementTime)

    case .updateLocation(let location):
      guard !currentState.isPaused else { return .empty() }
      let runningPoint = RunningPoint(coordinate: location.coordinate, timestamp: location.timestamp)
      return .concat([
        .just(.addRunningPoint(runningPoint)),
        .just(.updateTotalDistance(location.distance(from: currentState.runningPoints.last?.coordinate.location ?? location)))
      ])

    case .stopRun:
      timer?.invalidate()

      let totalTime = currentState.elapsedTime
      let totalDistance = currentState.totalDistance
      let averagePace = totalDistance > 0 ? totalTime / (totalDistance / 1000) : 0

      guard let recordId = currentState.recordId,
            let serverStartTime = currentState.serverStartTime else {
        print("recordId or serverStartTime is not available, skipping upload.")
        return .concat([
          .just(.setRunData(totalTime: totalTime, totalDistance: totalDistance, averagePace: averagePace)),
          .just(.setSessionState(.finished))
        ])
      }

      // TODO: 임시 칼로리 값
      let totalCalories = 0

      return .concat([
        .just(.setRunData(totalTime: totalTime, totalDistance: totalDistance, averagePace: averagePace)),
        .just(.setSessionState(.uploading)),
        runningCompletionUseCase.execute(
          recordId: recordId,
          startAt: serverStartTime,
          runningPoints: currentState.runningPoints,
          totalTime: totalTime,
          totalDistance: totalDistance,
          averagePace: averagePace,
          totalCalories: totalCalories
        )
        .asObservable()
          .flatMap { success -> Observable<Mutation> in
            return .concat([
              .just(.setUploadSuccess(success)),
              .just(.setSessionState(.finished))
            ])
          }
      ])

    case .uploadComplete:
      return .just(.setSessionState(.finished))
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

    case let .addRunningPoint(runningPoint):
      newState.runningPoints.append(runningPoint)
      newState.runningPath.append(runningPoint.coordinate)

    case let .updateTotalDistance(distance):
      newState.totalDistance += distance

    case let .setSessionState(sessionState):
      newState.sessionState = sessionState
      newState.isPaused = (sessionState == .paused)

    case let .setStartRunInfo(recordId, serverStartTime, localStartTime):
      newState.recordId = String(recordId)
      newState.serverStartTime = serverStartTime
      newState.localStartTime = localStartTime

    case let .setRunData(totalTime, totalDistance, averagePace):
      newState.totalTime = totalTime
      newState.totalDistance = totalDistance
      newState.averagePace = averagePace

    case let .setUploadSuccess(success):
      newState.isUploadSuccess = success
    }
    return newState
  }
}

public extension CLLocationCoordinate2D {
  func distance(to other: CLLocationCoordinate2D) -> Double {
    let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let location2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
    return location1.distance(from: location2)
  }

  var location: CLLocation {
    CLLocation(latitude: self.latitude, longitude: self.longitude)
  }
}
