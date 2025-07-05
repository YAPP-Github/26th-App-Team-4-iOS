//
//  LaunchViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit
import Then
import Core

public final class LaunchViewController: UIViewController, View {
  public var disposeBag = DisposeBag()

  weak var coordinator: LaunchCoordinator?

  private let titleLabel = UILabel().then {
    $0.text = "LaunchVC"
    $0.textColor = .red
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow
    setupUI()
  }

  public func bind(reactor: LaunchReactor) {
    reactor.action.onNext(.checkUserStatus)

    reactor.state.map { $0.userStatus }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] status in
        guard let self = self else { return }
        switch status {
        case .needsWalkthrough:
          self.coordinator?.pushWalkthroughFlow()
        case .loggedIn:
          self.coordinator?.pushMainTabBarFlow()
        }
      })
      .disposed(by: disposeBag)
  }

  private func setupUI() {
    view.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
