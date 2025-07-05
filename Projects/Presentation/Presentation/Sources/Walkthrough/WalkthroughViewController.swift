//
//  WalkthroughViewController.swift
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

public final class WalkthroughViewController: UIViewController, View {
  public var disposeBag = DisposeBag()

  weak var coordinator: WalkthroughCoordinator?

  private let titleLabel = UILabel().then {
    $0.text = "walkthrough"
    $0.font = DesignSystem.Fonts.largeTitle
    $0.textAlignment = .center
  }

  private let nextButton = UIButton(type: .system).then {
    $0.setTitle("Get Started", for: .normal)
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

  public func bind(reactor: WalkthroughReactor) {
    // Action
    nextButton.rx.tap
      .map { Reactor.Action.completeWalkthrough }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State
    reactor.state.map { $0.didComplete }
      .distinctUntilChanged()
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.coordinator?.didCompleteWalkthrough()
      })
      .disposed(by: disposeBag)
  }

  private func setupUI() {
    view.addSubview(titleLabel)
    view.addSubview(nextButton)

    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-50)
      $0.leading.trailing.equalToSuperview().inset(20)
    }

    nextButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(40)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
      $0.height.equalTo(50)
    }
  }
}
