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
    case setLastKnownLocation(CLLocation?)
    case setRunningGoals(paceGoal: TimeInterval?, distanceGoal: Double?, timeGoal: TimeInterval?)
    case setGoalsLoaded(Bool) // 목표 로딩 완료 여부 추적
    case setLastTimeFeedback50PercentGiven(Bool)
    case setLastTimeFeedback5MinBeforeGiven(Bool)
    case setLastTimeFeedback100PercentGiven(Bool)
    case setLastPaceFeedbackCategory(PaceFeedbackType?)
    case setLastPaceFeedbackTriggerDistance(Double)
    case setAveragePace(TimeInterval)
  }

  public struct State {
    var elapsedTime: TimeInterval = 0
    var runningPoints: [RunningPoint] = []
    var sessionState: SessionState = .idle
    var isUploadSuccess: Bool = false

    var recordId: String? = nil
    var totalTime: Double = 0
    var totalDistance: Double = 0
    var localStartTime: Date? = nil

    var runningPath: [CLLocationCoordinate2D] = []

    // 목표 관련 상태
    var goalDistance: Double? = nil
    var goalTime: TimeInterval? = nil // 초 단위
    var goalPace: TimeInterval? = nil // 초/km 단위
    var goalsLoaded: Bool = false // 목표 로딩 완료 여부

    // 피드백 상태 추적
    var lastDistanceFeedbackKm: Int = 0
    var lastTimeFeedback50PercentGiven: Bool = false
    var lastTimeFeedback5MinBeforeGiven: Bool = false
    var lastTimeFeedback100PercentGiven: Bool = false
    var lastPaceFeedbackCategory: PaceFeedbackType? = nil
    var lastPaceFeedbackTriggerDistance: Double = 0.0

    var lastKnownLocation: CLLocation? = nil

    var averagePaceInSeconds: TimeInterval = 0.0 // 초/km 단위로 직접 저장
    var averagePaceString: String { // 계산된 값을 사용하여 문자열만 반환
      guard averagePaceInSeconds > 0 else { return "00'00\"" }
      let minutes = Int(averagePaceInSeconds / 60)
      let seconds = Int(averagePaceInSeconds.truncatingRemainder(dividingBy: 60))
      return String(format: "%02d'%02d\"", minutes, seconds)
    }

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
  private let runningGoalUseCase: RunningGoalUseCase
  private var timer: Timer?

  public init(
    runningStartUseCase: RunningStartUseCaseType,
    runningCompletionUseCase: RunningCompletionUseCaseType,
    audioUseCase: AudioUseCase,
    runningGoalUseCase: RunningGoalUseCase
  ) {
    self.runningStartUseCase = runningStartUseCase
    self.runningCompletionUseCase = runningCompletionUseCase
    self.audioUseCase = audioUseCase
    self.runningGoalUseCase = runningGoalUseCase
    self.initialState = State()
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .startRun(startLocation):
      let localStartTime = Date()
      self.startTimer()

      let fetchGoalMutation = runningGoalUseCase.getRunningGoal()
        .asObservable()
        .flatMap { goal -> Observable<Mutation> in
          print("🔍 원시 목표 값 확인:")
          print("  - 원시 페이스 목표 (밀리초): \(goal.paceGoal != nil ? "\(goal.paceGoal!)" : "nil")")
          print("  - 원시 거리 목표 (미터): \(goal.distanceMeterGoal != nil ? "\(goal.distanceMeterGoal!)" : "nil")")
          print("  - 원시 시간 목표 (밀리초): \(goal.timeGoal != nil ? "\(goal.timeGoal!)" : "nil")")

          let serverPaceGoalSecondsPerKm = goal.paceGoal.map { TimeInterval($0) / 1000.0 }
          let serverTimeGoalSeconds = goal.timeGoal.map { TimeInterval($0) / 1000.0 }
          let serverDistanceGoalMeters = goal.distanceMeterGoal

          if let paceGoalMs = goal.paceGoal {
            let totalSeconds = TimeInterval(paceGoalMs) / 1000.0
            let minutes = Int(totalSeconds / 60)
            let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
            print("  - 목표 페이스 (분'초\"): \(String(format: "%02d'%02d\"", minutes, seconds))")
          } else {
            print("  - 목표 페이스 (분'초\"): 설정 안됨")
          }

          if let distanceGoalM = goal.distanceMeterGoal {
            let distanceKm = distanceGoalM / 1000.0
            print("  - 목표 거리 (km): \(String(format: "%.2fkm", distanceKm))")
          } else {
            print("  - 목표 거리 (km): 설정 안됨")
          }

          print("📊 목표 불러오기 완료 (서버 값 사용):")
          print("  - 목표 페이스: \(serverPaceGoalSecondsPerKm != nil ? String(format: "%.2f", serverPaceGoalSecondsPerKm!) + "초/km" : "설정 안됨")")
          print("  - 목표 거리: \(serverDistanceGoalMeters != nil ? String(format: "%.2f", serverDistanceGoalMeters!) + "m" : "설정 안됨")")
          print("  - 목표 시간: \(serverTimeGoalSeconds != nil ? String(format: "%.2f", serverTimeGoalSeconds!) + "초" : "설정 안됨")")

          return .concat([
            .just(.setRunningGoals(paceGoal: serverPaceGoalSecondsPerKm, distanceGoal: serverDistanceGoalMeters, timeGoal: serverTimeGoalSeconds)),
            .just(.setGoalsLoaded(true))
          ])
        }
        .catch { error -> Observable<Mutation> in
          print("❌ 목표 불러오기 오류: \(error.localizedDescription)")
          return .concat([
            .just(.setGoalsLoaded(false))
          ])
        }

      var mutations: [Observable<Mutation>] = [
        .just(.setStartRunInfo(localStartTime: localStartTime)),
        .just(.setSessionState(.inProgress))
      ]

      if let location = startLocation {
        mutations.append(.just(.setLastKnownLocation(location)))
        let runningPoint = RunningPoint(coordinate: location.coordinate, timestamp: localStartTime)
        mutations.append(.just(.addRunningPoint(runningPoint)))
      }

      return .concat([fetchGoalMutation] + mutations)

    case .togglePaused:
      let nextState: SessionState = currentState.sessionState == .paused ? .inProgress : .paused
      print("⏯️ 세션 상태 전환: \(nextState)")
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

        let newTotalDistance = currentState.totalDistance + distanceTraveled
        if newTotalDistance > 0 {
          let newAveragePace = (currentState.elapsedTime + 1) / (newTotalDistance / 1000.0)
          mutations.append(.just(.setAveragePace(newAveragePace)))
        } else {
          mutations.append(.just(.setAveragePace(0.0)))
        }

        let feedbackMutations = generateFeedbackMutations(distanceTraveled: distanceTraveled)
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
        print("⚠️ 시작 위치 또는 시간이 누락되어 업로드할 수 없습니다. 달리기 종료.")
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
              print("❌ 오류: recordId를 가져오지 못했습니다. 완료 API 호출 없이 종료.")
              return .concat([
                .just(.setSessionState(.finished)),
                .just(.setUploadSuccess(false))
              ])
            }
            print("⬆️ 달리기 데이터 업로드 중: recordId: \(recordId)")

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
              print("✅ 업로드 성공: \(success)")
              return .concat([
                .just(.setUploadSuccess(success)),
                .just(.setSessionState(.finished))
              ])
            }
          }
          .catch { error -> Observable<Mutation> in
            print("❌ stopRun 중 API 호출 오류: \(error.localizedDescription)")
            return .concat([
              .just(.setUploadSuccess(false)),
              .just(.setSessionState(.finished))
            ])
          }
      ])
    }
  }

  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self, self.currentState.sessionState == .inProgress else { return }
      self.action.onNext(.tick)
    }
  }

  private func generateFeedbackMutations(distanceTraveled: Double) -> Observable<Mutation> {
    let state = currentState
    var allFeedbackMutations: [Observable<Mutation>] = []

    // 목표가 로드되지 않았다면 피드백을 생성하지 않습니다.
    guard state.goalsLoaded else {
      return .empty()
    }

    let hasPaceGoal = state.goalPace != nil
    let hasDistanceGoal = state.goalDistance != nil
    let hasTimeGoal = state.goalTime != nil

    // 7. 거리 & 시간 & 페이스 목표를 설정한 경우, 페이스 오디오 피드백이 나간다.
    if hasDistanceGoal && hasTimeGoal && hasPaceGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    // 5. 거리 & 페이스 목표를 설정한 경우, 거리 & 페이스 피드백이 나간다.
    else if hasDistanceGoal && hasPaceGoal {
      allFeedbackMutations.append(_generateDistanceFeedback(distanceTraveled: distanceTraveled))
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    // 6. 시간 & 페이스 목표를 설정한 경우, 시간 & 페이스 피드백이 나간다.
    else if hasTimeGoal && hasPaceGoal {
      allFeedbackMutations.append(_generateTimeFeedback())
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    // 4. 거리 & 시간 목표를 설정한 경우, 페이스 오디오 피드백이 나간다.
    else if hasDistanceGoal && hasTimeGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    // 1. 페이스 목표만 설정한 경우, 페이스 오디오 피드백이 나간다.
    else if hasPaceGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    // 2. 거리 목표만 설정한 경우, 거리 오디오 피드백이 나간다.
    else if hasDistanceGoal {
      allFeedbackMutations.append(_generateDistanceFeedback(distanceTraveled: distanceTraveled))
    }
    // 3. 시간 목표만 설정한 경우, 시간 오디오 피드백이 나간다.
    else if hasTimeGoal {
      allFeedbackMutations.append(_generateTimeFeedback())
    }

    guard !allFeedbackMutations.isEmpty else {
      return .empty()
    }
    return Observable.concat(allFeedbackMutations)
  }

  private func _generateDistanceFeedback(distanceTraveled: Double) -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []

    let oldTotalDistance = state.totalDistance - distanceTraveled
    let newTotalDistance = state.totalDistance

    let lastKmReached = state.lastDistanceFeedbackKm
    let currentKmReached = Int(newTotalDistance / 1000.0)

    if currentKmReached > 0 && currentKmReached > lastKmReached {
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
      default:
        break
      }

      if let type = audioType {
        print("  📏 거리 피드백 트리거됨: \(kmToFeedback)km (\(type))")
        // TODO: 실제 오디오 재생 로직 (audioUseCase.playAudio...)
      }
      mutations.append(.just(.setLastDistanceFeedbackKm(kmToFeedback)))
    }

    if let goalDistance = state.goalDistance {
      if newTotalDistance >= goalDistance - 1000 && oldTotalDistance < goalDistance - 1000 {
        print("  📏 거리 피드백 트리거됨: 완주 1km 전")
        // TODO: 실제 오디오 재생 로직
      }
      if newTotalDistance >= goalDistance && oldTotalDistance < goalDistance {
        print("  📏 거리 피드백 트리거됨: 목표 거리 완주")
        // TODO: 실제 오디오 재생 로직
      }
    }

    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
  }

  private func _generateTimeFeedback() -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []

    if let goalTime = state.goalTime {
      let currentElapsedTime = state.elapsedTime

      let fiftyPercentTime = goalTime * 0.5
      if currentElapsedTime >= fiftyPercentTime && !state.lastTimeFeedback50PercentGiven {
        mutations.append(.just(.setLastTimeFeedback50PercentGiven(true)))
        print("  ⏱️ 시간 피드백 트리거됨: 50% 지점")
        // TODO: 실제 오디오 재생 로직
      }

      let fiveMinBeforeTime = goalTime - (5 * 60)
      if currentElapsedTime >= fiveMinBeforeTime && !state.lastTimeFeedback5MinBeforeGiven && fiveMinBeforeTime > 0 {
        mutations.append(.just(.setLastTimeFeedback5MinBeforeGiven(true)))
        print("  ⏱️ 시간 피드백 트리거됨: 5분 전")
        // TODO: 실제 오디오 재생 로직
      }

      if currentElapsedTime >= goalTime && !state.lastTimeFeedback100PercentGiven {
        mutations.append(.just(.setLastTimeFeedback100PercentGiven(true)))
        print("  ⏱️ 시간 피드백 트리거됨: 100% 지점")
        // TODO: 실제 오디오 재생 로직
      }
    }

    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
  }

  private func _generatePaceFeedback() -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []

    // 목표 페이스와 현재 평균 페이스가 유효한지 확인
    guard let goalPace = state.goalPace, state.averagePaceInSeconds > 0 else {
      return .empty()
    }

    let currentKm = Int(state.totalDistance / 1000.0) // 현재 몇 km를 넘었는지
    let lastFeedbackKm = Int(state.lastPaceFeedbackTriggerDistance / 1000.0) // 마지막으로 피드백을 준 km 지점

    // 현재 km 지점이 마지막 피드백 km 지점보다 크고, 0km 이상일 때만 피드백 트리거
    guard currentKm > 0 && currentKm > lastFeedbackKm else {
      return .empty()
    }

    let currentAveragePace = state.averagePaceInSeconds

    // 페이스 기준 (초/km)
    let fastThreshold = goalPace - 15.0 // 목표보다 15초/km 빠르면 fast
    let slowThreshold = goalPace + 30.0 // 목표보다 30초/km 느리면 slow

    var currentPaceCategory: PaceFeedbackType? = nil

    if currentAveragePace < fastThreshold {
      currentPaceCategory = .fast
    } else if currentAveragePace > slowThreshold {
      currentPaceCategory = .slow
    } else {
      currentPaceCategory = .good
    }

    // 새로운 1km 지점을 지났으면, 카테고리가 이전과 같든 다르든 피드백을 발생시킵니다.
    // 그리고 이 1km 지점에서의 페이스 카테고리와, 정확한 1km 지점을 기록합니다.
    if let category = currentPaceCategory {
      mutations.append(.just(.setLastPaceFeedbackCategory(category)))
      // 피드백 트리거 거리를 현재 통과한 정확한 킬로미터 지점으로 설정 (예: 1000.0m, 2000.0m)
      mutations.append(.just(.setLastPaceFeedbackTriggerDistance(Double(currentKm) * 1000.0)))
      print("  🏃 페이스 피드백 트리거됨: \(currentKm)km 지점 평균 페이스 - \(category.rawValue)")
      // TODO: 실제 오디오 재생 로직 (audioUseCase.playAudio...)
    }

    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
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
    case let .setLastKnownLocation(location):
      newState.lastKnownLocation = location
    case let .setRunningGoals(paceGoal, distanceGoal, timeGoal):
      newState.goalPace = paceGoal
      newState.goalDistance = distanceGoal
      newState.goalTime = timeGoal
    case let .setGoalsLoaded(loaded):
      newState.goalsLoaded = loaded
    case let .setLastTimeFeedback50PercentGiven(given):
      newState.lastTimeFeedback50PercentGiven = given
    case let .setLastTimeFeedback5MinBeforeGiven(given):
      newState.lastTimeFeedback5MinBeforeGiven = given
    case let .setLastTimeFeedback100PercentGiven(given):
      newState.lastTimeFeedback100PercentGiven = given
    case let .setLastPaceFeedbackCategory(category):
      newState.lastPaceFeedbackCategory = category
    case let .setLastPaceFeedbackTriggerDistance(distance):
      newState.lastPaceFeedbackTriggerDistance = distance
    case let .setAveragePace(pace):
      newState.averagePaceInSeconds = pace
    }
    return newState
  }
}
