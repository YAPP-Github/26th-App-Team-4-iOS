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
    container.autoregister(MainTabBarReactor.self, initializer: MainTabBarReactor.init)
    
    container.register(MainTabBarCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return MainTabBarCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
    
    container.register(MainTabBarController.self) { r in
      let viewController = MainTabBarController()
      return viewController
    }
  }
}
