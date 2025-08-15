//
//  MyPageAssembly.swift
//  Presentation
//
//  Created by JDeoks on 8/11/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class MyPageAssembly: Assembly {
  
  public init() {}
  
  public func assemble(container: Container) {
    container.register(MyPageCoordinator.self) { (r, navigationController: UINavigationController) in
      return MyPageCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
    
    // MARK: - 마이페이지
    container.autoregister(MyPageReactor.self, initializer: MyPageReactor.init)

    container.register(MyPageViewController.self) { r in
      guard let reactor = r.resolve(MyPageReactor.self) else {
        fatalError("Failed to resolve RecordListReactor.")
      }
      let vc = MyPageViewController()
      vc.reactor = reactor
      return vc
    }

    // MARK: - 체력 수준
    container.register(MyLevelSettingReactor.self) { r in
      return MyLevelSettingReactor()
    }

    container.register(MyLevelSettingViewController.self) { r in
      let vc = MyLevelSettingViewController()
      vc.reactor = r.resolve(MyLevelSettingReactor.self)
      return vc
    }
    
    
    // MARK: - 러닝 목표
    container.register(MyPurposeSettingReactor.self) { r in
      return MyPurposeSettingReactor()
    }
    
    container.register(MyPurposeSettingViewController.self) { r in
      let vc = MyPurposeSettingViewController()
      vc.reactor = r.resolve(MyPurposeSettingReactor.self)
      return vc
    }
    
    
    // MARK: - 프로필
    container.autoregister(MyProfileReactor.self, initializer: MyProfileReactor.init)

    container.register(MyProfileViewController.self) { r in
      let vc = MyProfileViewController()
      vc.reactor = r.resolve(MyProfileReactor.self)
      return vc
    }
    
    // MARK: - 탈퇴 화면
    container.register(DeleteAccountViewController.self) { (r, mode: DeleteAccountViewController.Mode) in
      let vc = DeleteAccountViewController(mode: mode)
      return vc
    }
    
    // MARK: - 러닝 설정
    container.register(MyRunningSettingReactor.self) { r in
      return MyRunningSettingReactor()
    }
    
    container.register(MyRunningSettingViewController.self) { r in
      let vc = MyRunningSettingViewController()
      vc.reactor = r.resolve(MyRunningSettingReactor.self)
      return vc
    }
    
    // MARK: - 알림 설정
    container.register(MyNotiSettingReactor.self) { r in
      return MyNotiSettingReactor()
    }
    
    container.register(MyNotiSettingViewController.self) { r in
      let vc = MyNotiSettingViewController()
      vc.reactor = r.resolve(MyNotiSettingReactor.self)
      return vc
    }
    
  }
}
