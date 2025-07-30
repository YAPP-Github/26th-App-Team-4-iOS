//
//  RunningViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/20/25.
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

final class RunningViewController: BaseViewController, View {
  typealias Reactor = RunningReactor

  weak var coordinator: RunningCoordinator?

  lazy var animationView = LottieAnimationView().then {
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
    $0.text = "1.87"
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
    $0.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    $0.tintColor = .white
    $0.imageView?.contentMode = .scaleAspectFit
  }

  private let secondaryActionButton = UIButton().then {
    $0.backgroundColor = FRColor.Bg.Interactive.secondary
    $0.layer.cornerRadius = 45
    $0.setImage(UIImage(systemName: "stop.fill"), for: .normal)
    $0.tintColor = .white
    $0.imageView?.contentMode = .scaleAspectFit
    $0.isHidden = true
  }

  private let playButton = UIButton().then {
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.layer.cornerRadius = 45
    $0.setImage(UIImage(systemName: "play.fill"), for: .normal)
    $0.tintColor = .white
    $0.imageView?.contentMode = .scaleAspectFit
    $0.isHidden = true
  }

  private var isPausedState: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
    playAnimationAndShowUI()
  }

  private func setupUI() {
    view.backgroundColor = .gray

    view.addSubview(topBackgroundView)
    view.addSubview(bottomContainerView)
    view.addSubview(animationView)

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
  }

  // MARK: - UI Binding
  private func bindUI() {
    isPausedState
      .asDriver()
      .drive(onNext: { [weak self] isPaused in
        guard let self = self else { return }
        self.updateUIForState(isPaused: isPaused)
      })
      .disposed(by: disposeBag)

    mainActionButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.isPausedState.accept(!self.isPausedState.value)
      })
      .disposed(by: disposeBag)

    secondaryActionButton.rx.tap
      .subscribe(with: self) { object, _ in
        // TODO: - 기록상세 화면으로 갈 수 있도록 수정 필요
        object.coordinator?.showRunningPaceSetting()
      }
      .disposed(by: disposeBag)

    playButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.isPausedState.accept(!object.isPausedState.value)
      }
      .disposed(by: disposeBag)
  }

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

  // MARK: - Animation and UI Presentation
  private func playAnimationAndShowUI() {
    animationView.play { [weak self] _ in
      guard let self = self else { return }
      self.animationView.isHidden = true
      self.topBackgroundView.isHidden = false
      self.bottomContainerView.isHidden = false
    }
  }

  func bind(reactor: RunningReactor) {

  }
}
