//
//  WalkthroughCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol WalkthroughCoordinator: Coordinator {
  func showLogin()
}

public final class WalkthroughCoordinatorImpl {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: Core.CoordinatorType = .walkthrough
  public weak var finishDelegate: CoordinatorFinishDelegate?
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  public func start() {
    let viewController = WalkthroughViewController()
    viewController.coordinator = self
    viewController.reactor = WalkthroughReactor()
    navigationController.setViewControllers([viewController], animated: true)
  }
}

extension WalkthroughCoordinatorImpl: WalkthroughCoordinator {
  public func showLogin() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
