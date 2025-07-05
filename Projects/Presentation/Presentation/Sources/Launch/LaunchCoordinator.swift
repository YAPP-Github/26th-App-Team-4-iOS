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

public protocol LaunchScreenCoordinatorDelegate: AnyObject {
  func pushWalkthroughFlow()
  func pushMainTabBarFlow()
}

public final class LaunchCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .launchScreen
  public var finishDelegate: CoordinatorFinishDelegate?

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

extension LaunchCoordinator: LaunchScreenCoordinatorDelegate {
  public func pushWalkthroughFlow() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }

  public func pushMainTabBarFlow() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
