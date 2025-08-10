//
//  AudioUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/6/25.
//

import Foundation
import RxSwift

public protocol AudioUseCase {
  func getCoachAudio() -> Single<Data>
  func getRunningInfoAudio(paceMills: String) -> Single<Data>
  func getDistanceFeedbackAudio(type: DistanceFeedbackType) -> Single<Data>
  func getPaceFeedbackAudio(type: String) -> Single<Data>
  func getTimeFeedbackAudio(type: String) -> Single<Data>
}

public final class AudioUseCaseImpl: AudioUseCase {
  private let audioRepository: AudioRepository

  public init(audioRepository: AudioRepository) {
    self.audioRepository = audioRepository
  }

  public func getCoachAudio() -> Single<Data> {
    return audioRepository.fetchCoachAudio()
  }

  public func getRunningInfoAudio(paceMills: String) -> Single<Data> {
    return audioRepository.fetchRunningInfo(paceMills: paceMills)
  }

  public func getDistanceFeedbackAudio(type: DistanceFeedbackType) -> Single<Data> {
    return audioRepository.fetchDistanceAudio(type: type)
  }

  public func getPaceFeedbackAudio(type: String) -> Single<Data> {
    return audioRepository.fetchPaceFeedbackAudio(type: type)
  }

  public func getTimeFeedbackAudio(type: String) -> Single<Data> {
    return audioRepository.fetchTimeFeedbackAudio(type: type)
  }
}
