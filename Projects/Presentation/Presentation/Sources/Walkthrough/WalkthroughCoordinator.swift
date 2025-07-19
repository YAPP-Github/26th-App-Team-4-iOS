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

public final class WalkthroughCoordinatorImpl: WalkthroughCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: Core.CoordinatorType = .walkthrough
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    let viewController = WalkthroughViewController()
    viewController.coordinator = self
    viewController.reactor = WalkthroughReactor()
    navigationController.setViewControllers([viewController], animated: true)
  }
}

extension WalkthroughCoordinatorImpl {
  public func showLogin() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
