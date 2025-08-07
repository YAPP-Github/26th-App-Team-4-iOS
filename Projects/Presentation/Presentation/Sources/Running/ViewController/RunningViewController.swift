//
//  RunningViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/20/25.
//

import UIKit
import Core
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import Lottie
import CoreLocation
import AVFoundation

final class RunningViewController: BaseViewController, View {
  typealias Reactor = RunningReactor

  weak var coordinator: RunningCoordinator?

  // MARK: - Properties

  private let locationManager = CLLocationManager()

  private var audioPlayer: AVAudioPlayer?

  private lazy var animationView = LottieAnimationView().then {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
    $0.animationSpeed = 1.0
    $0.animation = LottieAnimation.named("countdown", bundle: .module)
  }

  private let topBackgroundView = UIView().then {
    $0.backgroundColor = FRColor.Bg.Interactive.secondaryPressed
    $0.isHidden = true
  }

  private let distanceLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 80, weight: .bold)
    $0.textColor = FRColor.Fg.Text.Interactive.inverse
    $0.textAlignment = .center
    $0.text = "0.00"
  }

  private let unitLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 30, weight: .regular)
    $0.textColor = .gray700
    $0.textAlignment = .center
    $0.text = "km"
  }

  private let bottomContainerView = UIView().then {
    $0.backgroundColor = .baseWhite
    $0.layer.cornerRadius = 20
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.isHidden = true
  }

  private let paceTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.text = "평균 페이스"
    $0.textAlignment = .center
  }

  private let paceValueLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "00'00\""
    $0.textAlignment = .center
  }

  private let timeTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.text = "시간"
    $0.textAlignment = .center
  }

  private let timeValueLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "00:00:00"
    $0.textAlignment = .center
  }

  private let verticalDivider = UIView().then {
    $0.backgroundColor = .systemGray5
  }

  private let mainActionButton = UIButton().then {
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.layer.cornerRadius = 55
    let resizedImage = UIImage(systemName: "pause.fill")?
      .resized(to: CGSize(width: 32, height: 32))?
      .withRenderingMode(.alwaysTemplate)
    $0.setImage(resizedImage, for: .normal)
    $0.tintColor = .white
    $0.imageView?.contentMode = .scaleAspectFit
  }

  private let secondaryActionButton = UIButton().then {
    $0.backgroundColor = FRColor.Bg.Interactive.secondary
    $0.layer.cornerRadius = 45
    let resizedImage = UIImage(systemName: "stop.fill")?
      .resized(to: CGSize(width: 32, height: 32))?
      .withRenderingMode(.alwaysTemplate)
    $0.setImage(resizedImage, for: .normal)
    $0.tintColor = .white
    $0.imageView?.contentMode = .scaleAspectFit
    $0.isHidden = true
  }

  private let playButton = UIButton().then {
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.layer.cornerRadius = 45
    let resizedImage = UIImage(systemName: "play.fill")?
      .resized(to: CGSize(width: 32, height: 32))?
      .withRenderingMode(.alwaysTemplate)
    $0.setImage(resizedImage, for: .normal)
    $0.tintColor = .white
    $0.imageView?.contentMode = .scaleAspectFit
    $0.isHidden = true
  }

  private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
    $0.color = .orange
    $0.hidesWhenStopped = true
    $0.isHidden = true
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupLocationManager()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)

    if let reactor = self.reactor {
      playAnimationAndShowUI(reactor: reactor)
    }
  }

  // MARK: - UI Setup

  private func setupUI() {
    view.backgroundColor = .gray

    view.addSubview(topBackgroundView)
    view.addSubview(bottomContainerView)
    view.addSubview(animationView)
    view.addSubview(loadingIndicator)

    topBackgroundView.addSubview(distanceLabel)
    topBackgroundView.addSubview(unitLabel)

    bottomContainerView.addSubview(paceTitleLabel)
    bottomContainerView.addSubview(paceValueLabel)
    bottomContainerView.addSubview(timeTitleLabel)
    bottomContainerView.addSubview(timeValueLabel)
    bottomContainerView.addSubview(verticalDivider)

    bottomContainerView.addSubview(mainActionButton)
    bottomContainerView.addSubview(secondaryActionButton)
    bottomContainerView.addSubview(playButton)

    animationView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    topBackgroundView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.6)
    }

    distanceLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    unitLabel.snp.makeConstraints {
      $0.top.equalTo(distanceLabel.snp.bottom).offset(5)
      $0.centerX.equalToSuperview()
    }

    bottomContainerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(346)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    paceTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(verticalDivider.snp.leading)
    }

    paceValueLabel.snp.makeConstraints {
      $0.top.equalTo(paceTitleLabel.snp.bottom).offset(5)
      $0.centerX.equalTo(paceTitleLabel)
    }

    timeTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalTo(verticalDivider.snp.trailing)
      $0.trailing.equalToSuperview()
    }

    timeValueLabel.snp.makeConstraints {
      $0.top.equalTo(timeTitleLabel.snp.bottom).offset(5)
      $0.centerX.equalTo(timeTitleLabel)
    }

    verticalDivider.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(paceTitleLabel.snp.top)
      $0.bottom.equalTo(paceValueLabel.snp.bottom)
      $0.width.equalTo(1)
    }

    mainActionButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
      $0.width.height.equalTo(110)
    }

    secondaryActionButton.snp.makeConstraints {
      $0.centerY.equalTo(mainActionButton)
      $0.width.height.equalTo(90)
      $0.centerX.equalToSuperview().offset(-(90 / 2 + 25.5))
    }

    playButton.snp.makeConstraints {
      $0.centerY.equalTo(mainActionButton)
      $0.width.height.equalTo(90)
      $0.centerX.equalToSuperview().offset(90 / 2 + 25.5)
    }

    loadingIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  // MARK: - Location Manager

  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    // 위치 권한 요청
    locationManager.requestWhenInUseAuthorization()
  }

  // MARK: - UI Logic

  private func updateUIForState(isPaused: Bool) {
    if isPaused {
      topBackgroundView.backgroundColor = FRColor.Bg.secondary
      distanceLabel.textColor = FRColor.Fg.Text.primary

      mainActionButton.isHidden = true
      secondaryActionButton.isHidden = false
      playButton.isHidden = false
    } else {
      topBackgroundView.backgroundColor = FRColor.Bg.Interactive.secondaryPressed
      distanceLabel.textColor = FRColor.Fg.Text.Interactive.inverse

      mainActionButton.isHidden = false
      secondaryActionButton.isHidden = true
      playButton.isHidden = true
    }
  }

  private func playAnimationAndShowUI(reactor: RunningReactor) {
    animationView.play { [weak self] _ in
      guard let self = self else { return }
      self.locationManager.startUpdatingLocation()
      reactor.action.onNext(.startRun(startLocation: self.locationManager.location))
    }
  }

  // MARK: - Binding

  func bind(reactor: RunningReactor) {
    // MARK: Action
    mainActionButton.rx.tap
      .map { Reactor.Action.togglePaused }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    playButton.rx.tap
      .map { Reactor.Action.togglePaused }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    secondaryActionButton.rx.tap
      .map { Reactor.Action.stopRun }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // MARK: State
    reactor.state.map(\.isPaused)
      .distinctUntilChanged()
      .bind(with: self) { this, isPaused in
        this.updateUIForState(isPaused: isPaused)
      }
      .disposed(by: disposeBag)

    reactor.state.map { $0.elapsedTimeString }
      .distinctUntilChanged()
      .bind(to: timeValueLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map(\.totalDistance)
      .distinctUntilChanged()
      .map { String(format: "%.2f", $0 / 1000) }
      .bind(to: distanceLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map(\.averagePaceString)
      .distinctUntilChanged()
      .bind(to: paceValueLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map(\.sessionState)
      .distinctUntilChanged()
      .bind(with: self) { this, sessionState in
        switch sessionState {
        case .idle:
          this.animationView.isHidden = false
          this.topBackgroundView.isHidden = true
          this.bottomContainerView.isHidden = true
          this.loadingIndicator.stopAnimating()
          this.loadingIndicator.isHidden = true
        case .inProgress:
          this.animationView.isHidden = true
          this.topBackgroundView.isHidden = false
          this.bottomContainerView.isHidden = false
          this.loadingIndicator.stopAnimating()
          this.loadingIndicator.isHidden = true
          this.updateUIForState(isPaused: false)
        case .paused:
          this.animationView.isHidden = true
          this.topBackgroundView.isHidden = false
          this.bottomContainerView.isHidden = false
          this.loadingIndicator.stopAnimating()
          this.loadingIndicator.isHidden = true
          this.updateUIForState(isPaused: true)
        case .uploading:
          this.animationView.isHidden = true
          this.topBackgroundView.isHidden = true
          this.bottomContainerView.isHidden = true
          this.loadingIndicator.isHidden = false
          this.loadingIndicator.startAnimating()
        case .finished, .error:
          this.loadingIndicator.stopAnimating()
          this.loadingIndicator.isHidden = true
        }
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.sessionState)
      .distinctUntilChanged()
      .filter { $0 == .finished }
      .bind(with: self) { this, _ in
        this.coordinator?.showRunningResult()
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isUploadSuccess)
      .filter { $0 }
      .distinctUntilChanged()
      .bind(with: self) { this, _ in
        this.coordinator?.showRunningResult()
      }
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.audioToPlay }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] audioData in
        self?.playAudio(with: audioData)
      })
      .disposed(by: disposeBag)
  }

  private func playAudio(with data: Data) {
    do {
      audioPlayer = try AVAudioPlayer(data: data)
      audioPlayer?.delegate = self
      audioPlayer?.play()
    } catch {
      print("Error playing audio: \(error.localizedDescription)")
      self.reactor?.action.onNext(.audioPlayed)
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension RunningViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    case .notDetermined, .denied, .restricted:
      // TODO: - 권한이 없을 경우, 사용자에게 안내하는 로직 필요
      print("Location access denied.")
    @unknown default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    if let reactor = self.reactor {
      if reactor.currentState.sessionState == .idle {
        reactor.action.onNext(.startRun(startLocation: self.locationManager.location))
      } else {
        reactor.action.onNext(.updateLocation(location))
      }
    }
  }
}

// MARK: - AVAudioPlayerDelegate

extension RunningViewController: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.reactor?.action.onNext(.audioPlayed)
  }
}
