//
//  AudioRepository.swift
//  Domain
//
//  Created by dong eun shin on 8/6/25.
//

import Foundation
import RxSwift

public protocol AudioRepository {
  func fetchCoachAudio() -> Single<Data>
  func fetchRunningInfo(paceMills: String) -> Single<Data>
  func fetchDistanceAudio(type: DistanceFeedbackType) -> Single<Data>
  func fetchPaceFeedbackAudio(type: String) -> Single<Data>
  func fetchTimeFeedbackAudio(type: String) -> Single<Data>
}

public enum DistanceFeedbackType: String {
  case pass1Km = "DISTANCE_PASS_1KM"
  case pass2Km = "DISTANCE_PASS_2KM"
  case pass3Km = "DISTANCE_PASS_3KM"
  case pass4Km = "DISTANCE_PASS_4KM"
  case pass5Km = "DISTANCE_PASS_5KM"
  case pass6Km = "DISTANCE_PASS_6KM"
  case pass7Km = "DISTANCE_PASS_7KM"
  case pass8Km = "DISTANCE_PASS_8KM"
  case pass9Km = "DISTANCE_PASS_9KM"
  case pass10Km = "DISTANCE_PASS_10KM"

  case left1Km = "DISTANCE_LEFT_1KM"
  case finish = "DISTANCE_FINISH"
}

public enum PaceFeedbackType: String {
  case fast = "PACE_FAST"
  case slow = "PACE_SLOW"
  case good = "PACE_GOOD"
}

public enum TimeFeedbackType: String {
  case passHalf = "TIME_PASS_HALF"
  case left5Min = "TIME_LEFT_5MIN"
  case finish = "TIME_FINISH"
}
