//
//  MainTabBarCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol MainTabBarCoordinator: Coordinator {

}

public final class MainTabBarCoordinatorImpl: MainTabBarCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .mainTabBar
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    guard let viewController = resolver.resolve(MainTabBarController.self) else {
      fatalError("Failed to resolve MainTabBarViewController. Ensure it is registered correctly in Swinject.")
    }
    navigationController.setViewControllers([viewController], animated: false)
  }
}
