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
    container.autoregister(WalkthroughReactor.self, initializer: WalkthroughReactor.init)
    
    container.register(WalkthroughCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return WalkthroughCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
    container.register(WalkthroughViewController.self) { r in
      guard let reactor = r.resolve(WalkthroughReactor.self) else {
        fatalError("Failed to resolve WalkthroughReactor.")
      }
      let viewController = WalkthroughViewController()
      viewController.reactor = reactor
      return viewController
    }
  }
}
