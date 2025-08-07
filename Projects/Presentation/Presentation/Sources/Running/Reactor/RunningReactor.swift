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
    case incrementTime
    case addRunningPoint(RunningPoint)
    case setSessionState(SessionState)
    case setUploadSuccess(Bool)
    case setStartRunInfo(localStartTime: Date)
    case setRunData(totalTime: TimeInterval, totalDistance: Double)
    case updateTotalDistance(Double)
    case setLastDistanceFeedbackKm(Int)
    case setAudioToPlay(Data?)
    case setLastKnownLocation(CLLocation?)
  }

  public struct State {
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
    var lastKnownLocation: CLLocation? = nil

    var elapsedTimeString: String {
      let hours = Int(elapsedTime) / 3600
      let minutes = (Int(elapsedTime) % 3600) / 60
      let seconds = Int(elapsedTime) % 60
      return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var averagePaceString: String {
      guard totalDistance > 0 else { return "00'00\"" }
      let paceInSecondsPerKm = (elapsedTime / (totalDistance / 1000.0))
      let minutes = Int(paceInSecondsPerKm / 60)
      let seconds = Int(paceInSecondsPerKm.truncatingRemainder(dividingBy: 60))
      return String(format: "%02d'%02d\"", minutes, seconds)
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
      let localStartTime = Date()
      self.startTimer()

      var mutations: [Observable<Mutation>] = [
        .just(.setStartRunInfo(localStartTime: localStartTime)),
        .just(.setSessionState(.inProgress))
      ]

      if let location = startLocation {
        mutations.append(.just(.setLastKnownLocation(location)))
        let runningPoint = RunningPoint(coordinate: location.coordinate, timestamp: localStartTime)
        mutations.append(.just(.addRunningPoint(runningPoint)))
      }

      return .concat(mutations)

    case .togglePaused:
      let nextState: SessionState = currentState.sessionState == .paused ? .inProgress : .paused
      if nextState == .inProgress {
        self.startTimer()
      } else {
        timer?.invalidate()
      }
      return .just(.setSessionState(nextState))

    case .tick:
      guard currentState.sessionState != .paused else { return .empty() }

      var mutations: [Observable<Mutation>] = [.just(.incrementTime)]

      if let currentLocation = currentState.lastKnownLocation {
        let timestamp = Date()
        let newRunningPoint = RunningPoint(coordinate: currentLocation.coordinate, timestamp: timestamp)

        var distanceTraveled = 0.0
        if let lastPoint = currentState.runningPoints.last {
          distanceTraveled = currentLocation.distance(from: lastPoint.coordinate.location)
        }

        mutations.append(.just(.addRunningPoint(newRunningPoint)))
        mutations.append(.just(.updateTotalDistance(distanceTraveled)))

        let feedbackMutations = checkDistanceFeedback(distance: distanceTraveled)
        mutations.append(feedbackMutations)
      }

      return .concat(mutations)

    case let .updateLocation(location):
      return .just(.setLastKnownLocation(location))

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
      guard let self = self, self.currentState.sessionState == .inProgress else { return }
      self.action.onNext(.tick)
    }
  }

  private func checkDistanceFeedback(distance: Double) -> Observable<Mutation> {
    let state = currentState
    guard state.sessionState == .inProgress else { return .empty() }

    var mutationsToEmit: [Observable<Mutation>] = []

    let oldTotalDistance = state.totalDistance
    let newTotalDistance = state.totalDistance + distance

    let currentKmReached = Int(newTotalDistance / 1000)

    if currentKmReached > state.lastDistanceFeedbackKm {
      let kmToFeedback = currentKmReached

      var audioType: DistanceFeedbackType? = nil
      switch kmToFeedback {
      case 1: audioType = .pass1Km
      case 2: audioType = .pass2Km
      case 3: audioType = .pass3Km
      case 4: audioType = .pass4Km
      case 5: audioType = .pass5Km
      case 6: audioType = .pass6Km
      case 7: audioType = .pass7Km
      case 8: audioType = .pass8Km
      case 9: audioType = .pass9Km
      case 10: audioType = .pass10Km
      default: break
      }

      if let type = audioType {
        let audioObs = audioUseCase.getDistanceFeedbackAudio(type: type)
          .asObservable()
          .delay(.milliseconds(500), scheduler: MainScheduler.instance)
          .compactMap { data -> Mutation? in
            return .setAudioToPlay(data)
          }
          .catch { error -> Observable<Mutation> in
            print("Error getting audio data: \(error.localizedDescription)")
            return .empty()
          }
        mutationsToEmit.append(audioObs)
      }

      mutationsToEmit.append(.just(.setLastDistanceFeedbackKm(kmToFeedback)))
    }

    if let goalDistance = state.goalDistance {
      if newTotalDistance >= goalDistance - 1000 && oldTotalDistance < goalDistance - 1000 {
        let audioObs = audioUseCase.getDistanceFeedbackAudio(type: .left1Km)
          .asObservable()
          .delay(.milliseconds(500), scheduler: MainScheduler.instance)
          .compactMap { data -> Mutation? in
            return .setAudioToPlay(data)
          }
          .catch { _ in .empty() }
        mutationsToEmit.append(audioObs)
      }
      if newTotalDistance >= goalDistance && oldTotalDistance < goalDistance {
        let audioObs = audioUseCase.getDistanceFeedbackAudio(type: .finish)
          .asObservable()
          .delay(.milliseconds(500), scheduler: MainScheduler.instance)
          .compactMap { data -> Mutation? in
            return .setAudioToPlay(data)
          }
          .catch { _ in .empty() }
        mutationsToEmit.append(audioObs)
      }
    }

    guard !mutationsToEmit.isEmpty else { return .empty() }

    return Observable.concat(mutationsToEmit)
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .incrementTime:
      newState.elapsedTime += 1
    case let .addRunningPoint(runningPoint):
      newState.runningPoints.append(runningPoint)
      newState.runningPath.append(runningPoint.coordinate)
    case let .updateTotalDistance(distance):
      newState.totalDistance += distance
    case let .setSessionState(sessionState):
      newState.sessionState = sessionState
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
    case let .setLastKnownLocation(location):
      newState.lastKnownLocation = location
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
