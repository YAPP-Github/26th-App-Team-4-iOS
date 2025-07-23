//
//  MainTabBarAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/19/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class MainTabBarAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.register(MainTabBarCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return MainTabBarCoordinatorImpl(navigationController: navigationController, resolver: r)
    }

    // Home
    container.autoregister(HomeReactor.self, initializer: HomeReactor.init)

    container.register(HomeCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return HomeCoordinatorImpl(navigationController: navigationController, resolver: r)
    }

    container.register(HomeViewController.self) { r in
      guard let reactor = r.resolve(HomeReactor.self) else {
        fatalError("Failed to resolve HomeReactor.")
      }
      let viewController = HomeViewController()
      viewController.reactor = reactor
      return viewController
    }
  }
}
