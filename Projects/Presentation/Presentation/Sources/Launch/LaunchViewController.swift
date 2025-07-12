//
//  LaunchViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

import UIKit
import ReactorKit

import Core

public final class LaunchViewController: BaseViewController, View {
  weak var coordinator: LaunchScreenCoordinator?

  private let logoImageView = UIImageView().then {
    let image = UIImage(named: "LaunchScreenLogo", in: Bundle.module, compatibleWith: nil)
    print(image)
    $0.image = UIImage(named: "LaunchScreenLogo", in: Bundle.module, compatibleWith: nil)
  }
  
  public override func initUI() {
    print("\(type(of: self)) - \(#function)")
    
    super.initUI()
    
    view.addSubview(logoImageView)
    logoImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  public func bind(reactor: LaunchReactor) {
//    self.rx.viewDidAppear
//      .subscribe(with: self) { object, _ in
//        reactor.action.onNext(.checkUserStatus)
//      }
//      .disposed(by: disposeBag)
    
    reactor.state.map { $0.userStatus }
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(with: self) { object, status in
        switch status {
        case .needsWalkthrough:
          object.coordinator?.showWalkthrough()
        case .loggedIn:
          object.coordinator?.showMainTabBar()
        }
      }
      .disposed(by: disposeBag)
  }
}
