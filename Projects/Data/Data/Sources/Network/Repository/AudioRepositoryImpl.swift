//
//  AudioRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on 8/6/25.
//

import Foundation
import Moya
import RxSwift
import Domain

public final class AudioRepositoryImpl: AudioRepository {
  private let provider: MoyaProvider<AudioAPI>

  public init(provider: MoyaProvider<AudioAPI> = MoyaProvider<AudioAPI>()) {
    self.provider = provider
  }

  public func fetchCoachAudio() -> Single<Data> {
    return provider.rx.request(.coach).map { $0.data }
  }

  public func fetchRunningInfo(paceMills: String) -> Single<Data> {
    return provider.rx.request(.runningInfo(paceMills: paceMills)).map { $0.data }
  }

  public func fetchDistanceAudio(type: String) -> Single<Data> {
    return provider.rx.request(.distance(type: type)).map { $0.data }
  }

  public func fetchPaceFeedbackAudio(type: String) -> Single<Data> {
    return provider.rx.request(.paceFeedback(type: type)).map { $0.data }
  }

  public func fetchTimeFeedbackAudio(type: String) -> Single<Data> {
    return provider.rx.request(.timeFeedback(type: type)).map { $0.data }
  }
}
