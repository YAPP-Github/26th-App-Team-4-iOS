//
//  WalkthroughAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/19/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class WalkthroughAssembly: Assembly {
  public init() {}
  
  public func assemble(container: Container) {
    container.autoregister(WalkThroughReactor.self, initializer: WalkThroughReactor.init)
    
    container.register(WalkThroughCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return WalkThroughCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
    
    container.register(WalkThroughViewController.self) { r in
      guard let reactor = r.resolve(WalkThroughReactor.self) else {
        fatalError("Failed to resolve WalkthroughReactor.")
      }
      let viewController = WalkThroughViewController()
      viewController.reactor = reactor
      return viewController
    }
  }
}
