//
//  FirstRunningOnboardingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/20/25.
//

import UIKit
import SnapKit
import Then
import Lottie
import Core

final class FirstRunningOnboardingViewController: BaseViewController {

  weak var coordinator: RunningCoordinator?

  // MARK: - UI Elements

  lazy var animationView = LottieAnimationView().then {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
    $0.animationSpeed = 1.0
    $0.animation = LottieAnimation.named("running_onboarding", bundle: .module)
  }

  let backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = UIColor(hex: "#D9D9D9")
  }

  let setGoalButton = UIButton().then {
    $0.setTitle("목표 설정하기", for: .normal)
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    $0.isHidden = true
  }

  let doLaterButton = UIButton().then {
    $0.setTitle("다음에 하기", for: .normal)
    $0.backgroundColor = .clear
    $0.setTitleColor(FRColor.Fg.Nuetral.gray600, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    $0.isHidden = true
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = FRColor.Fg.Nuetral.gray1000

    setupLayout()
    addTargets()
    bind()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    playAnimationAndShowButtons()
  }

  // MARK: - Setup Layout

  private func setupLayout() {
    view.addSubview(animationView)
    view.addSubview(backButton)
    view.addSubview(setGoalButton)
    view.addSubview(doLaterButton)

    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(6)
      make.leading.equalToSuperview().offset(6)
      make.width.height.equalTo(44)
    }

    animationView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(335)
      make.height.equalTo(668)
    }

    setGoalButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(54)
    }

    doLaterButton.snp.makeConstraints { make in
      make.top.equalTo(setGoalButton.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }
  }

  // MARK: - Animation and Button Visibility

  private func playAnimationAndShowButtons() {
    animationView.play { [weak self] finished in
      guard let self = self else { return }
      if finished {
        UIView.animate(withDuration: 0.5) {
          self.setGoalButton.isHidden = false
          self.doLaterButton.isHidden = false
        }
      }
    }
  }

  // MARK: - Button Actions

  private func addTargets() {
    setGoalButton.addTarget(self, action: #selector(setGoalButtonTapped), for: .touchUpInside)
    doLaterButton.addTarget(self, action: #selector(doLaterButtonTapped), for: .touchUpInside)
  }

  @objc private func setGoalButtonTapped() {
    coordinator?.showFirstRunningGoalSettingIntro()
  }

  @objc private func doLaterButtonTapped() {
    coordinator?.showRunning()
  }

  private func bind() {
    backButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.dismissRunningFlow()
      })
      .disposed(by: disposeBag)
  }
}
