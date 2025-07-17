//
//  MainTabBarCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol MainTabBarCoordinatorDelegate: AnyObject {
  
}

public final class MainTabBarCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .mainTabBar
  public weak var finishDelegate: CoordinatorFinishDelegate?

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    let mainTabBarController = MainTabBarController()
    navigationController.setViewControllers([mainTabBarController], animated: true)
  }
}
