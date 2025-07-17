//
//  LaunchCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import RxSwift
import Domain
import Core

public protocol LaunchScreenCoordinator: Coordinator {
  func showWalkthrough()
  func showMainTabBar()
}

public final class LaunchCoordinatorImpl {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .launchScreen
  public weak var finishDelegate: CoordinatorFinishDelegate?
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  public func start() {
    let viewController = LaunchViewController()
    viewController.coordinator = self
    viewController.reactor = LaunchReactor()
    navigationController.setViewControllers([viewController], animated: false)
  }
}

extension LaunchCoordinatorImpl: LaunchScreenCoordinator {
  public func showWalkthrough() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
  
  public func showMainTabBar() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
