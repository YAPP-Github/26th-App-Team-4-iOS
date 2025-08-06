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
    case idle
    case inProgress
    case paused
    case finished
    case uploading
    case error
  }

  public enum Action {
    case startRun(startLocation: CLLocation?)
    case togglePaused
    case tick
    case stopRun
    case updateLocation(CLLocation)
    case audioPlayed
  }

  public enum Mutation {
    case setPaused(Bool)
    case incrementTime
    case addRunningPoint(RunningPoint)
    case setSessionState(SessionState)
    case setUploadSuccess(Bool)
    case setStartRunInfo(localStartTime: Date)
    case setRunData(totalTime: TimeInterval, totalDistance: Double)
    case updateTotalDistance(Double)
    case setLastDistanceFeedbackKm(Int)
    case setAudioToPlay(Data?)
  }

  public struct State {
    var isPaused: Bool = false
    var elapsedTime: TimeInterval = 0
    var runningPoints: [RunningPoint] = []
    var sessionState: SessionState = .idle
    var isUploadSuccess: Bool = false

    var recordId: String? = nil
    var totalTime: TimeInterval = 0
    var totalDistance: Double = 0
    var localStartTime: Date? = nil

    var runningPath: [CLLocationCoordinate2D] = []

    var goalDistance: Double? = nil
    var lastDistanceFeedbackKm: Int = 0
    var audioToPlay: Data? = nil

    var elapsedTimeString: String {
      let hours = Int(elapsedTime) / 3600
      let minutes = (Int(elapsedTime) % 3600) / 60
      let seconds = Int(elapsedTime) % 60
      return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
  }

  public let initialState: State
  private let runningStartUseCase: RunningStartUseCaseType
  private let runningCompletionUseCase: RunningCompletionUseCaseType
  private let audioUseCase: AudioUseCase
  private var timer: Timer?

  public init(
    runningStartUseCase: RunningStartUseCaseType,
    runningCompletionUseCase: RunningCompletionUseCaseType,
    audioUseCase: AudioUseCase,
    goalDistance: Double? = nil
  ) {
    self.runningStartUseCase = runningStartUseCase
    self.runningCompletionUseCase = runningCompletionUseCase
    self.audioUseCase = audioUseCase
    self.initialState = State(goalDistance: goalDistance)
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .startRun(startLocation):
      guard let location = startLocation else { return .empty() }
      let localStartTime = Date()

      let runningPoint = RunningPoint(coordinate: location.coordinate, timestamp: localStartTime)
      self.startTimer()

      return .concat([
        .just(.setStartRunInfo(localStartTime: localStartTime)),
        .just(.addRunningPoint(runningPoint)),
        .just(.setSessionState(.inProgress))
      ])

    case .togglePaused:
      let nextState: SessionState = currentState.isPaused ? .inProgress : .paused
      return .just(.setSessionState(nextState))

    case .tick:
      guard !currentState.isPaused else { return .empty() }
      return .just(.incrementTime)

    case let .updateLocation(location):
      guard !currentState.isPaused else { return .empty() }

      let runningPoint = RunningPoint(coordinate: location.coordinate, timestamp: location.timestamp)
      let distance = location.distance(from: currentState.runningPoints.last?.coordinate.location ?? location)

      let distanceFeedbackMutation = checkDistanceFeedback(distance: distance)

      return .concat([
        .just(.addRunningPoint(runningPoint)),
        .just(.updateTotalDistance(distance)),
        distanceFeedbackMutation
      ])

    case .stopRun:
      timer?.invalidate()

      let totalTime = currentState.elapsedTime
      let totalDistance = currentState.totalDistance

      let displayDataMutation: Observable<Mutation> = .just(.setRunData(totalTime: totalTime, totalDistance: totalDistance))

      guard let startLocation = currentState.runningPoints.first?.coordinate.location,
            let localStartTime = currentState.localStartTime else {
        print("Start location or time is missing, cannot upload. Finishing run.")
        return .concat([
          displayDataMutation,
          .just(.setSessionState(.finished))
        ])
      }

      return .concat([
        displayDataMutation,
        .just(.setSessionState(.uploading)),

        self.runningStartUseCase.execute(startLocation: startLocation, timeStamp: localStartTime)
          .asObservable()
          .flatMap { recordId -> Observable<Mutation> in
            guard let recordId = recordId else {
              print("Error: Failed to get recordId. Finishing without completion API.")
              return .concat([
                .just(.setSessionState(.finished)),
                .just(.setUploadSuccess(false))
              ])
            }

            let totalCalories = 0
            let averagePace = totalDistance > 0 ? totalTime / (totalDistance / 1000) : 0

            return self.runningCompletionUseCase.execute(
              recordId: String(recordId),
              startAt: localStartTime,
              runningPoints: self.currentState.runningPoints,
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
          }
          .catch { error -> Observable<Mutation> in
            print("Error in API calls: \(error.localizedDescription)")
            return .concat([
              .just(.setUploadSuccess(false)),
              .just(.setSessionState(.finished))
            ])
          }
      ])

    case .audioPlayed:
      return .just(.setAudioToPlay(nil))
    }
  }

  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.action.onNext(.tick)
    }
  }

  private func checkDistanceFeedback(distance: Double) -> Observable<Mutation> {
    let state = currentState
    guard state.sessionState == .inProgress else { return .empty() }

    var audioObservables: [Observable<Data>] = []

    let lastKm = Int(state.totalDistance / 1000)
    let currentKm = Int((state.totalDistance + distance) / 1000)

    if currentKm > lastKm {
      switch currentKm {
      case 1:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass1Km).asObservable())
      case 2:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass2Km).asObservable())
      case 3:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass3Km).asObservable())
      case 4:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass4Km).asObservable())
      case 5:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass5Km).asObservable())
      case 6:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass6Km).asObservable())
      case 7:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass7Km).asObservable())
      case 8:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass8Km).asObservable())
      case 9:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass9Km).asObservable())
      case 10:
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .pass10Km).asObservable())
      default:
        break
      }
    }

    if let goalDistance = state.goalDistance {
      if (state.totalDistance + distance) >= goalDistance - 1000 && state.totalDistance < goalDistance - 1000 {
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .left1Km).asObservable())
      }
      if (state.totalDistance + distance) >= goalDistance && state.totalDistance < goalDistance {
        audioObservables.append(audioUseCase.getDistanceFeedbackAudio(type: .finish).asObservable())
      }
    }

    guard !audioObservables.isEmpty else { return .empty() }

    return Observable.concat(audioObservables.map { audioObs in
      audioObs
        .delay(.milliseconds(500), scheduler: MainScheduler.instance)
        .flatMap { audioData -> Observable<Mutation> in
          return .just(.setAudioToPlay(audioData))
        }
        .catch { _ in .empty() }
    })
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
    case let .setStartRunInfo(localStartTime):
      newState.localStartTime = localStartTime
    case let .setRunData(totalTime, totalDistance):
      newState.totalTime = totalTime
      newState.totalDistance = totalDistance
    case let .setUploadSuccess(success):
      newState.isUploadSuccess = success
    case let .setLastDistanceFeedbackKm(km):
      newState.lastDistanceFeedbackKm = km
    case let .setAudioToPlay(data):
      newState.audioToPlay = data
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
