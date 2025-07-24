//
//  OnboardingAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/5/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class OnboardingAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.autoregister(OnboardingReactor.self, initializer: OnboardingReactor.init)

    container.register(OnboardingCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return OnboardingCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
    
    container.register(OnboardingViewController.self) { r in
      guard let reactor = r.resolve(OnboardingReactor.self) else {
        fatalError("Failed to resolve OnboardingReactor.")
      }
      let viewController = OnboardingViewController()
      viewController.reactor = reactor
      return viewController
    }

    container.register(RunnerTypeViewController.self) { r in
//      guard let reactor = r.resolve(.self) else {
//        fatalError("Failed to resolve .")
//      }
      let viewController = RunnerTypeViewController()
//      viewController.reactor = reactor
      return viewController
    }
  }
}
