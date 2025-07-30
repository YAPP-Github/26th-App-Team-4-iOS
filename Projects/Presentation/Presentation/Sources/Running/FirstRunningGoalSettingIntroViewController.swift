//
//  FirstRunningGoalSettingIntroViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/21/25.
//

import UIKit
import Core
import SnapKit
import Then

final class FirstRunningGoalSettingIntroViewController: BaseViewController {

  weak var coordinator: RunningCoordinator?

  // MARK: - UI Elements

  let backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    $0.tintColor = .white
  }

  let skipButton = UIButton().then {
    $0.setTitle("건너뛰기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
  }

  let titleLabel = UILabel().then {
    $0.text = "러닝 목표를 선택해 주세요!"
    $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    $0.textColor = FRColor.Fg.Nuetral.gray0
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  let subtitleLabel = UILabel().then {
    $0.text = "한번 달릴 때 마다\n달성하고 싶은 목표를 설정해 보세요."
    $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    $0.textColor = FRColor.Fg.Nuetral.gray400
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }

  let timeGoalButton = UIButton().then {
    $0.backgroundColor = FRColor.Fg.Nuetral.gray900
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true

    var config = UIButton.Configuration.plain()
    config.image = UIImage(named: "clock", in: .module, with: nil)?.resized(to: CGSize(width: 45.56, height: 47.56))
    config.imageColorTransformer = UIConfigurationColorTransformer { _ in .white }

    config.title = "목표 시간"
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = UIFont.systemFont(ofSize: 18, weight: .bold)
      outgoing.foregroundColor = FRColor.Fg.Text.Interactive.inverse
      return outgoing
    }

    config.subtitle = "한번에 몇분을\n목표로 달릴지 정해요"
    config.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      outgoing.foregroundColor = FRColor.Fg.Nuetral.gray500
      return outgoing
    }

    config.imagePlacement = .top
    config.imagePadding = 19.22
    config.titleAlignment = .center
    $0.configuration = config
  }

  let distanceGoalButton = UIButton().then {
    $0.backgroundColor = FRColor.Fg.Nuetral.gray900
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true

    var config = UIButton.Configuration.plain()
    config.image = UIImage(named: "track", in: .module, with: nil)?.resizedToFill(to: CGSize(width: 70, height: 48))
    config.imageColorTransformer = UIConfigurationColorTransformer { _ in .white }

    config.title = "목표 거리"
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = UIFont.systemFont(ofSize: 18, weight: .bold)
      outgoing.foregroundColor = FRColor.Fg.Text.Interactive.inverse
      return outgoing
    }

    config.subtitle = "한번에 몇 km를\n목표로 달릴지 정해요"
    config.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      outgoing.foregroundColor = FRColor.Fg.Nuetral.gray500
      return outgoing
    }

    config.imagePlacement = .top
    config.imagePadding = 16
    config.titleAlignment = .center
    $0.configuration = config
  }

  let footerStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 4
    $0.backgroundColor = FRColor.Fg.Nuetral.gray200
    $0.layer.cornerRadius = 16

    let iconImageView = UIImageView().then {
      $0.image = UIImage(systemName: "questionmark.circle.fill")
      $0.tintColor = FRColor.Fg.Text.secondary
      $0.contentMode = .scaleAspectFit
      $0.snp.makeConstraints { make in
        make.width.height.equalTo(24)
      }
    }

    let messageLabel = UILabel().then {
      $0.text = "목표는 마이페이지에서 수정할 수 있어요!"
      $0.textColor = FRColor.Fg.Text.secondary
      $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      $0.numberOfLines = 1
    }

    $0.addArrangedSubview(iconImageView)
    $0.addArrangedSubview(messageLabel)
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)

    setupLayout()
    addTargets()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  // MARK: - Setup Layout

  private func setupLayout() {
    view.addSubview(backButton)
    view.addSubview(skipButton)
    view.addSubview(titleLabel)
    view.addSubview(subtitleLabel)
    view.addSubview(timeGoalButton)
    view.addSubview(distanceGoalButton)
    view.addSubview(footerStackView)

    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
      make.leading.equalToSuperview().offset(20)
      make.width.height.equalTo(30)
    }

    skipButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
      make.trailing.equalToSuperview().offset(-20)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(136)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    timeGoalButton.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(44)
      make.leading.equalToSuperview().offset(20)
      make.width.equalTo(160)
      make.height.equalTo(200)
    }

    distanceGoalButton.snp.makeConstraints { make in
      make.top.equalTo(timeGoalButton.snp.top)
      make.leading.equalTo(timeGoalButton.snp.trailing).offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(timeGoalButton.snp.height)
    }

    footerStackView.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
      make.centerX.equalToSuperview()
      make.width.equalTo(335)
      make.height.equalTo(56)
    }
  }

  // MARK: - Button Actions

  private func addTargets() {
    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    timeGoalButton.addTarget(self, action: #selector(timeGoalButtonTapped), for: .touchUpInside)
    distanceGoalButton.addTarget(self, action: #selector(distanceGoalButtonTapped), for: .touchUpInside)
  }

  @objc private func backButtonTapped() {
    print("Back button tapped!")
    coordinator?.pop()
  }

  @objc private func skipButtonTapped() {
    print("Skip button tapped!")
    coordinator?.showRunning()
  }

  @objc private func timeGoalButtonTapped() {
    coordinator?.showFirstRunningGoalSetting(goalInputType: .time)
  }

  @objc private func distanceGoalButtonTapped() {
    coordinator?.showFirstRunningGoalSetting(goalInputType: .distance)
  }
}
