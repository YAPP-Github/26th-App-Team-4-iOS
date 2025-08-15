//
//  MyPageCoordinator.swift
//  Presentation
//
//  Created by JDeoks on 8/11/25.
//

import UIKit
import Swinject
import Core

public protocol MyPageCoordinator: Coordinator {
  func showMyLevelSetting()
  func showMyPurposeSetting()
  func showMyProfile()
  func showDeleteAccount(mode: DeleteAccountViewController.Mode)
  func showPaceCountSettingVC()
  func showRunningSetting()
  func showMyNotiSettingVC()
}

public final class MyPageCoordinatorImpl: MyPageCoordinator {
  
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .myPage
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver
  
  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }
  
  /// 탭 선택 시 최초 진입
  public func start() {
    guard let viewController = resolver.resolve(MyPageViewController.self) else {
      fatalError("Failed to resolve RecordListViewController. Ensure it is registered in Swinject.")
    }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: false)
  }
  
  public func showMyLevelSetting() {
    guard let viewController = resolver.resolve(MyLevelSettingViewController.self) else {
      fatalError("Failed to resolve RecordListViewController. Ensure it is registered in Swinject.")
    }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func showMyPurposeSetting() {
    guard let viewController = resolver.resolve(MyPurposeSettingViewController.self) else {
      fatalError("Failed to resolve RecordListViewController. Ensure it is registered in Swinject.")
    }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func showMyProfile() {
    guard let viewController = resolver.resolve(MyProfileViewController.self) else {
      fatalError("Failed to resolve RecordListViewController. Ensure it is registered in Swinject.")
    }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func showDeleteAccount(mode: DeleteAccountViewController.Mode) {
    let vc = resolver.resolve(DeleteAccountViewController.self, argument: mode)!
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  public func showPaceCountSettingVC() {
    let vc = resolver.resolve(MyGoalSettingViewController.self)!
    navigationController.pushViewController(vc, animated: true)
  }
  
  public func showRunningSetting() {
    let vc = resolver.resolve(MyRunningSettingViewController.self)!
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  public func showMyNotiSettingVC() {
    let vc = resolver.resolve(MyNotiSettingViewController.self)!
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
}

// MARK: - CoordinatorFinishDelegate
extension MyPageCoordinatorImpl: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    // 필요에 따라 childCoordinators에서 제거
    childCoordinators.removeAll { $0 === childCoordinator }
  }
}
