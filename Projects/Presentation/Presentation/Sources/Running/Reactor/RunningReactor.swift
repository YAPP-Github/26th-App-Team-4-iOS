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
    // case audioPlayed // 오디오 재생 관련 액션 제거
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
    // case processAudio(Data) // 오디오 처리 관련 Mutation 제거
    // case setAudioToPlay((UUID, Data)?) // 오디오 재생 관련 Mutation 제거
    case setLastKnownLocation(CLLocation?)
    case setRunningGoals(paceGoal: TimeInterval?, distanceGoal: Double?, timeGoal: TimeInterval?) // 목표 설정 Mutation
    case setGoalsLoaded(Bool) // 목표 로딩 완료 여부 추적
    case setLastTimeFeedback50PercentGiven(Bool)
    case setLastTimeFeedback5MinBeforeGiven(Bool)
    case setLastTimeFeedback100PercentGiven(Bool)
    case setLastPaceFeedbackCategory(PaceFeedbackType?) // 페이스 피드백 카테고리 추적
    case setLastPaceFeedbackTriggerDistance(Double) // 마지막 페이스 피드백 발생 거리
    // case playNextQueuedAudio // 오디오 재생 관련 Mutation 제거
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
    
    // 목표 조합에 따른 피드백 우선순위
    if hasDistanceGoal && hasTimeGoal && hasPaceGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    } else if hasDistanceGoal && hasPaceGoal {
      allFeedbackMutations.append(_generateDistanceFeedback(distanceTraveled: distanceTraveled))
      allFeedbackMutations.append(_generatePaceFeedback())
    } else if hasTimeGoal && hasPaceGoal {
      allFeedbackMutations.append(_generateTimeFeedback())
      allFeedbackMutations.append(_generatePaceFeedback())
    } else if hasDistanceGoal && hasTimeGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    } else if hasPaceGoal {
      allFeedbackMutations.append(_generatePaceFeedback())
    } else if hasDistanceGoal {
      allFeedbackMutations.append(_generateDistanceFeedback(distanceTraveled: distanceTraveled))
    } else if hasTimeGoal {
      allFeedbackMutations.append(_generateTimeFeedback())
    } else {
      // 설정된 목표 없음
    }
    
    guard !allFeedbackMutations.isEmpty else {
      return .empty()
    }
    return Observable.concat(allFeedbackMutations)
  }
  
  // 거리 피드백 생성 함수
  private func _generateDistanceFeedback(distanceTraveled: Double) -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []
    
    let oldTotalDistance = state.totalDistance - distanceTraveled
    let newTotalDistance = state.totalDistance
    
    let lastKmReached = state.lastDistanceFeedbackKm
    let currentKmReached = Int(newTotalDistance / 1000.0)
    
    // 킬로미터 달성 피드백 (현재 도달한 킬로미터에 대해서만)
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
      }
      mutations.append(.just(.setLastDistanceFeedbackKm(kmToFeedback)))
    }
    
    // 목표 거리 관련 피드백 (1km 전, 완주)
    if let goalDistance = state.goalDistance {
      // 1km 전
      if newTotalDistance >= goalDistance - 1000 && oldTotalDistance < goalDistance - 1000 {
        print("  📏 거리 피드백 트리거됨: 완주 1km 전")
      }
      // 목표 거리 완주
      if newTotalDistance >= goalDistance && oldTotalDistance < goalDistance {
        print("  📏 거리 피드백 트리거됨: 목표 거리 완주")
      }
    }
    
    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
  }
  
  // 시간 피드백 생성 함수
  private func _generateTimeFeedback() -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []
    
    if let goalTime = state.goalTime {
      let currentElapsedTime = state.elapsedTime
      
      // 목표 시간의 50% 지점
      let fiftyPercentTime = goalTime * 0.5
      if currentElapsedTime >= fiftyPercentTime && !state.lastTimeFeedback50PercentGiven {
        mutations.append(.just(.setLastTimeFeedback50PercentGiven(true)))
        print("  ⏱️ 시간 피드백 트리거됨: 50% 지점")
      }
      
      // 목표 시간 5분 전
      let fiveMinBeforeTime = goalTime - (5 * 60)
      if currentElapsedTime >= fiveMinBeforeTime && !state.lastTimeFeedback5MinBeforeGiven && fiveMinBeforeTime > 0 {
        mutations.append(.just(.setLastTimeFeedback5MinBeforeGiven(true)))
        print("  ⏱️ 시간 피드백 트리거됨: 5분 전")
      }
      
      if currentElapsedTime >= goalTime && !state.lastTimeFeedback100PercentGiven {
        mutations.append(.just(.setLastTimeFeedback100PercentGiven(true)))
        print("  ⏱️ 시간 피드백 트리거됨: 100% 지점")
      }
    }
    
    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
  }
  
  // 페이스 피드백 생성 함수
  private func _generatePaceFeedback() -> Observable<Mutation> {
    let state = currentState
    var mutations: [Observable<Mutation>] = []
    
    guard state.totalDistance >= 1000.0, let goalPace = state.goalPace else {
      return .empty()
    }
    
    let distanceSinceLastPaceFeedback = state.totalDistance - state.lastPaceFeedbackTriggerDistance
    guard distanceSinceLastPaceFeedback >= 1000.0 else {
      return .empty()
    }
    
    let currentPaceSecondsPerKm = convertPaceStringToSeconds(state.averagePaceString)
    
    // 페이스 기준 (초/km)
    let fastThreshold = goalPace - 15.0
    let slowThreshold = goalPace + 30.0
    
    var currentPaceCategory: PaceFeedbackType? = nil
    
    if currentPaceSecondsPerKm < fastThreshold {
      currentPaceCategory = .fast
    } else if currentPaceSecondsPerKm > slowThreshold {
      currentPaceCategory = .slow
    } else {
      currentPaceCategory = .good
    }
    
    if let category = currentPaceCategory {
      mutations.append(.just(.setLastPaceFeedbackCategory(category)))
      mutations.append(.just(.setLastPaceFeedbackTriggerDistance(state.totalDistance)))
      print("  🏃 페이스 피드백 트리거됨: 카테고리 \(category.rawValue)")
    }
    
    guard !mutations.isEmpty else { return .empty() }
    return Observable.concat(mutations)
  }
  
  private func convertPaceStringToSeconds(_ paceString: String) -> TimeInterval {
    let components = paceString.replacingOccurrences(of: "\"", with: "").split(separator: "'")
    guard components.count == 2,
          let minutes = TimeInterval(components[0]),
          let seconds = TimeInterval(components[1]) else {
      return 0
    }
    return minutes * 60 + seconds
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
