//
//  OnboardingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit
import Then
import Core

public final class OnboardingViewController: UIViewController, View {
  public var disposeBag = DisposeBag()

  private let titleLabel = UILabel().then {
    $0.text = "Complete Your Profile"
    $0.font = DesignSystem.Fonts.largeTitle
    $0.textAlignment = .center
  }

  private let completeButton = UIButton(type: .system).then {
    $0.setTitle("Complete Onboarding", for: .normal)
    $0.titleLabel?.font = DesignSystem.Fonts.headline
    $0.backgroundColor = DesignSystem.Colors.primary
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 8
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = DesignSystem.Colors.background
    setupUI()
  }

  public func bind(reactor: OnboardingReactor) {
    // Action
    completeButton.rx.tap
      .map { Reactor.Action.completeOnboardingTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State
    reactor.state.map { $0.isCompleted }
      .filter { $0 }
      .take(1)
      .bind(onNext: { [weak self] _ in
        print("Onboarding completed in VC, coordinator will navigate.")
      })
      .disposed(by: disposeBag)
  }

  private func setupUI() {
    view.addSubview(titleLabel)
    view.addSubview(completeButton)

    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-50)
      $0.leading.trailing.equalToSuperview().inset(20)
    }

    completeButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(40)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
      $0.height.equalTo(50)
    }
  }
}
