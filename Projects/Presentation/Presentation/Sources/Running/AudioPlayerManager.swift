//
//  AudioPlayerManager.swift
//  Presentation
//
//  Created by dong eun shin on 8/11/25.
//

import Foundation
import AVFoundation
import RxSwift
import Domain

public enum DistanceFeedbackType: Equatable {
  case passKm(Int)
  case left1Km
  case finish

  var serverRequestValue: String {
    switch self {
    case .passKm(let km):
      return "DISTANCE_PASS_\(km)KM"
    case .left1Km:
      return "DISTANCE_LEFT_1KM"
    case .finish:
      return "DISTANCE_FINISH"
    }
  }
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

public protocol AudioPlayerManagerType {
  var isPlaying: Bool { get }
  func playAudio(for event: AudioFeedbackEvent, completion: @escaping (Bool) -> Void)
}

public enum AudioFeedbackEvent: Equatable {
  case distance(DistanceFeedbackType)
  case pace(PaceFeedbackType)
  case time(TimeFeedbackType)
}

final class AudioPlayerManager: NSObject, AudioPlayerManagerType, AVAudioPlayerDelegate {

  private let audioUseCase: AudioUseCase
  private var audioPlayer: AVAudioPlayer?
  private var completionHandler: ((Bool) -> Void)?
  private var disposeBag = DisposeBag()

  var isPlaying: Bool {
    return audioPlayer?.isPlaying ?? false
  }

  init(audioUseCase: AudioUseCase) {
    self.audioUseCase = audioUseCase
    super.init()
  }

  func playAudio(for event: AudioFeedbackEvent, completion: @escaping (Bool) -> Void) {
    guard !isPlaying else {
      completion(false)
      return
    }

    self.completionHandler = completion

    var fetchAudioObservable: Single<Data>
    switch event {
    case .distance(let type):
      let audioTypeString = type.serverRequestValue
      fetchAudioObservable = audioUseCase.getDistanceFeedbackAudio(type: audioTypeString)
    case .pace(let type):
      fetchAudioObservable = audioUseCase.getPaceFeedbackAudio(type: type.rawValue)
    case .time(let type):
      fetchAudioObservable = audioUseCase.getTimeFeedbackAudio(type: type.rawValue)
    }

    fetchAudioObservable
      .subscribe(onSuccess: { [weak self] audioData in
        self?.setupAndPlay(audioData: audioData)
      }, onFailure: { [weak self] error in
        print("❌ [AudioPlayerManager] 오디오 데이터 로드 실패: \(error.localizedDescription)")
        self?.completionHandler?(false)
        self?.completionHandler = nil
      })
      .disposed(by: disposeBag)
  }

  private func setupAndPlay(audioData: Data) {
    do {
      audioPlayer = try AVAudioPlayer(data: audioData)
      audioPlayer?.delegate = self
      audioPlayer?.play()
    } catch {
      print("❌ [AudioPlayerManager] 오디오 재생 실패: \(error.localizedDescription)")
      self.completionHandler?(false)
      self.completionHandler = nil
    }
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    print("✅ [AudioPlayerManager] 오디오 재생 완료.")
    self.completionHandler?(flag)
    self.completionHandler = nil
    self.audioPlayer = nil
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    print("❌ [AudioPlayerManager] 오디오 디코딩 오류 발생: \(error?.localizedDescription ?? "알 수 없음")")
    self.completionHandler?(false)
    self.completionHandler = nil
    self.audioPlayer = nil
  }
}
