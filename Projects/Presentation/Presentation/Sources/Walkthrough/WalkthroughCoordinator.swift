//
//  WalkthroughCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol WalkThroughCoordinator: Coordinator {
  func showLogin()
}

public final class WalkThroughCoordinatorImpl: WalkThroughCoordinator {
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
    guard let viewController = resolver.resolve(WalkThroughViewController.self) else {
      fatalError("Failed to resolve WalkthroughViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    viewController.reactor = WalkThroughReactor()
    navigationController.setViewControllers([viewController], animated: true)
  }
}

extension WalkThroughCoordinatorImpl {
  public func showLogin() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
