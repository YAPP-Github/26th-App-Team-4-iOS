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
    case dequeueAudio(AudioFeedbackEvent)
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
    case setGoalsLoaded(Bool)
    case setLastTimeFeedback50PercentGiven(Bool)
    case setLastTimeFeedback5MinBeforeGiven(Bool)
    case setLastTimeFeedback100PercentGiven(Bool)
    case setLastPaceFeedbackCategory(PaceFeedbackType?)
    case setLastPaceFeedbackTriggerDistance(Double)
    case setAveragePace(TimeInterval)
    case enqueueAudio(AudioFeedbackEvent)
    case dequeueAudio(AudioFeedbackEvent)
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

    var goalDistance: Double? = nil
    var goalTime: TimeInterval? = nil
    var goalPace: TimeInterval? = nil
    var goalsLoaded: Bool = false

    var lastDistanceFeedbackKm: Int = 0
    var lastTimeFeedback50PercentGiven: Bool = false
    var lastTimeFeedback5MinBeforeGiven: Bool = false
    var lastTimeFeedback100PercentGiven: Bool = false
    var lastPaceFeedbackCategory: PaceFeedbackType? = nil
    var lastPaceFeedbackTriggerDistance: Double = 0.0

    var lastKnownLocation: CLLocation? = nil

    var averagePaceInSeconds: TimeInterval = 0.0
    var averagePaceString: String {
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

    // 오디오 이벤트를 담을 큐
    var audioQueue: [AudioFeedbackEvent] = []
  }

  public let initialState: State
  private let runningStartUseCase: RunningStartUseCaseType
  private let runningCompletionUseCase: RunningCompletionUseCaseType
  private let audioUseCase: AudioUseCase
  private let runningGoalUseCase: RunningGoalUseCase
  private let audioManager: AudioPlayerManagerType
  private var disposeBag = DisposeBag()
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
    self.audioManager = AudioPlayerManager(audioUseCase: audioUseCase)
    self.initialState = State()

    self.state.map { $0.audioQueue }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.playNextAudioIfNeeded()
      })
      .disposed(by: disposeBag)
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .startRun(startLocation):
      let localStartTime = Date()
      self.startTimer()

      let fetchGoalMutation = runningGoalUseCase.getRunningGoal()
        .asObservable()
        .flatMap { goal -> Observable<Mutation> in
          let serverPaceGoalSecondsPerKm = goal.paceGoal.map { TimeInterval($0) }
          let serverTimeGoalSeconds = goal.timeGoal.map { TimeInterval($0) }
          let serverDistanceGoalMeters = goal.distanceMeterGoal

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
      }

      return .concat(mutations).flatMap { mutation -> Observable<Mutation> in
        if case let .updateTotalDistance(distanceTraveled) = mutation {
          let newTotalDistance = self.currentState.totalDistance + distanceTraveled
          return .concat(
            .just(mutation),
            self.generateFeedbackMutations(totalDistance: newTotalDistance)
          )
        }
        return .just(mutation)
      }

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
    case let .dequeueAudio(event):
      return .just(.dequeueAudio(event))
    }
  }

  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self, self.currentState.sessionState == .inProgress else { return }
      self.action.onNext(.tick)
    }
  }

  private func playNextAudioIfNeeded() {
    guard !currentState.audioQueue.isEmpty, !audioManager.isPlaying else { return }

    let nextEvent = currentState.audioQueue.first!
    print("▶️ 총\(currentState.audioQueue.count)개. 오디오 큐에서 다음 항목 재생: \(nextEvent)")

    audioManager.playAudio(for: nextEvent) { [weak self] success in
      guard let self = self, success else { return }
      self.action.onNext(.dequeueAudio(nextEvent))
    }
  }

  private func generateFeedbackMutations(totalDistance: Double) -> Observable<Mutation> {
    let state = currentState
    var allFeedbackMutations: [Observable<Mutation>] = []

    guard state.goalsLoaded else {
      return .empty()
    }

    let hasPaceGoal = state.goalPace != nil
    let hasDistanceGoal = state.goalDistance != nil
    let hasTimeGoal = state.goalTime != nil

    // 목표 설정에 따라 피드백 로직을 분기
    if hasDistanceGoal && hasPaceGoal {
      allFeedbackMutations.append(_generateDistanceFeedback(totalDistance: totalDistance))
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    else if hasDistanceGoal {
      allFeedbackMutations.append(_generateDistanceFeedback(totalDistance: totalDistance))
    }
    else if hasTimeGoal && hasPaceGoal {
      allFeedbackMutations.append(_generateTimeFeedback())
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    else if hasDistanceGoal && hasTimeGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    else if hasPaceGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    }
    else if hasTimeGoal {
      allFeedbackMutations.append(_generateTimeFeedback())
    }

    guard !allFeedbackMutations.isEmpty else {
      return .empty()
    }
    return Observable.concat(allFeedbackMutations)
  }

  private func _generateDistanceFeedback(totalDistance: Double) -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []

    let lastKmReached = state.lastDistanceFeedbackKm
    let currentKmReached = Int(totalDistance / 1000.0)

    guard
      currentKmReached > lastKmReached,
      let goalDistance = state.goalDistance
    else {
      return .empty()
    }

    let goalKm = Int(goalDistance / 1000.0)
    let oneKmBeforeGoalKm = Int((goalDistance - 1000) / 1000.0)

    // 1. 목표 완주 피드백
    if currentKmReached >= goalKm {
      print(" 📏 거리 피드백 트리거됨: 목표 거리 완주")
      mutations.append(.just(.enqueueAudio(.distance(.finish))))
      mutations.append(.just(.setLastDistanceFeedbackKm(currentKmReached)))
    }
    // 2. 완주 1km 전 피드백
    else if currentKmReached == oneKmBeforeGoalKm {
      print(" 📏 거리 피드백 트리거됨: 완주 1km 전")
      mutations.append(.just(.enqueueAudio(.distance(.left1Km))))
      mutations.append(.just(.setLastDistanceFeedbackKm(currentKmReached)))
    }
    // 3. 1km 단위 일반 피드백
    else if (1...49).contains(currentKmReached) {
      let audioType = DistanceFeedbackType.passKm(currentKmReached)
      print(" 📏 거리 피드백 트리거됨: \(currentKmReached)km (\(audioType))")
      mutations.append(.just(.enqueueAudio(.distance(audioType))))
      mutations.append(.just(.setLastDistanceFeedbackKm(currentKmReached)))
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
        print(" ⏱️ 시간 피드백 트리거됨: 50% 지점")
        mutations.append(.just(.enqueueAudio(.time(.passHalf))))
      }

      let fiveMinBeforeTime = goalTime - (5 * 60)
      if currentElapsedTime >= fiveMinBeforeTime && !state.lastTimeFeedback5MinBeforeGiven && fiveMinBeforeTime > 0 {
        mutations.append(.just(.setLastTimeFeedback5MinBeforeGiven(true)))
        print(" ⏱️ 시간 피드백 트리거됨: 5분 전")
        mutations.append(.just(.enqueueAudio(.time(.left5Min))))
      }

      if currentElapsedTime >= goalTime && !state.lastTimeFeedback100PercentGiven {
        mutations.append(.just(.setLastTimeFeedback100PercentGiven(true)))
        print(" ⏱️ 시간 피드백 트리거됨: 100% 지점")
        mutations.append(.just(.enqueueAudio(.time(.finish))))
      }
    }

    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
  }

  private func _generatePaceFeedback() -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []

    guard let goalPace = state.goalPace, state.averagePaceInSeconds > 0 else {
      return .empty()
    }

    let currentKm = Int(state.totalDistance / 1000.0)
    let lastFeedbackKm = Int(state.lastPaceFeedbackTriggerDistance / 1000.0)

    guard currentKm > 0 && currentKm > lastFeedbackKm else {
      return .empty()
    }

    let currentAveragePace = state.averagePaceInSeconds

    let fastThreshold = goalPace - 15.0
    let slowThreshold = goalPace + 30.0

    var currentPaceCategory: PaceFeedbackType? = nil

    if currentAveragePace < fastThreshold {
      currentPaceCategory = .fast
    } else if currentAveragePace > slowThreshold {
      currentPaceCategory = .slow
    } else {
      currentPaceCategory = .good
    }

    if let category = currentPaceCategory {
      mutations.append(.just(.setLastPaceFeedbackCategory(category)))
      mutations.append(.just(.setLastPaceFeedbackTriggerDistance(Double(currentKm) * 1000.0)))
      print(" 🏃 페이스 피드백 트리거됨: \(currentKm)km 지점 평균 페이스 - \(category.rawValue)")
      mutations.append(.just(.enqueueAudio(.pace(category))))
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
    case let .enqueueAudio(event):
      if !newState.audioQueue.contains(where: { $0 == event }) {
        newState.audioQueue.append(event)
      }
    case let .dequeueAudio(event):
      if newState.audioQueue.first == event {
        newState.audioQueue.removeFirst()
      } else {
        print("⚠️ [Queue Error] 큐의 첫 번째 항목이 예상과 다릅니다. 현재 큐 상태: \(newState.audioQueue)")
      }
    }
    return newState
  }
}
