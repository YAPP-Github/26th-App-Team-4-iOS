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

  weak var coordinator: OnboardingCoordinator?

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
    view.addSubview(completeButton)

    completeButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(40)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
      $0.height.equalTo(50)
    }
  }
}
