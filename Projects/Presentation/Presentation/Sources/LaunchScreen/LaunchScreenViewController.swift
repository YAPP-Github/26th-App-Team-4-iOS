//
//  LaunchScreenViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/7/25.
//

import UIKit

import ReactorKit
import Then

import Domain
import Core

public final class LaunchScreenViewController: BaseViewController {
  
  private let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "LaunchScreenLogo", in: Bundle.module, compatibleWith: nil)
  }
  
  public override func initUI() {
    super.initUI()
    self.view.backgroundColor = .orange
    
    view.addSubview(logoImageView)
    logoImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  func bind(reactor: LaunchScreenReactor) {
    self.rx.viewDidAppear
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)
  }
}
