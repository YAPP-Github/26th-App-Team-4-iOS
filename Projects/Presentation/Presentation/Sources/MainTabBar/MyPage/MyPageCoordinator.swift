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
}

// MARK: - CoordinatorFinishDelegate
extension MyPageCoordinatorImpl: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    // 필요에 따라 childCoordinators에서 제거
    childCoordinators.removeAll { $0 === childCoordinator }
  }
}
