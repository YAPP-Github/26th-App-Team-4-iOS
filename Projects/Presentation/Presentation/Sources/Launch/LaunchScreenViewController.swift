//
//  LaunchViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

import UIKit
import ReactorKit

public final class LaunchViewController: UIViewController, View {
  public var disposeBag = DisposeBag()

  weak var coordinator: LaunchScreenCoordinator?

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
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
          self.coordinator?.showWalkthrough()
        case .loggedIn:
          self.coordinator?.showMainTabBar()
        }
      })
      .disposed(by: disposeBag)
  }
}
