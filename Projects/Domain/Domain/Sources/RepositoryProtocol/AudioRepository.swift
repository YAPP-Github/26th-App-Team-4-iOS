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
  func fetchDistanceAudio(type: String) -> Single<Data>
  func fetchPaceFeedbackAudio(type: String) -> Single<Data>
  func fetchTimeFeedbackAudio(type: String) -> Single<Data>
}
