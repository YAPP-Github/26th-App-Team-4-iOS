//
//  LaunchCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import RxSwift
import Core

public protocol LaunchScreenCoordinatorDelegate: AnyObject {
  func showWalkthroughFlow()
  func showMainTabBarFlow()
}

public protocol LaunchScreenCoordinator: Coordinator {
  func showWalkthrough()
  func showMainTabBar()
}

public final class LaunchCoordinatorImpl: LaunchScreenCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .launchScreen
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public weak var launchScreenCoordinatorDelegate: LaunchScreenCoordinatorDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    guard let viewController = resolver.resolve(LaunchViewController.self) else {
      fatalError("Failed to resolve LaunchViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self

    navigationController.setViewControllers([viewController], animated: false)
  }
}

extension LaunchCoordinatorImpl {
  public func showWalkthrough() {
    launchScreenCoordinatorDelegate?.showWalkthroughFlow()
  }

  public func showMainTabBar() {
    launchScreenCoordinatorDelegate?.showMainTabBarFlow()
  }
}
