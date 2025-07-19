//
//  LaunchAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/5/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class LaunchAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.autoregister(LaunchReactor.self, initializer: LaunchReactor.init)

    container.register(LaunchCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return LaunchCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
    
    container.register(LaunchViewController.self) { r in
      guard let reactor = r.resolve(LaunchReactor.self) else {
        fatalError("Failed to resolve LaunchReactor. Ensure LaunchReactor is registered correctly.")
      }
      let viewController = LaunchViewController()
      viewController.reactor = reactor
      return viewController
    }
  }
}
