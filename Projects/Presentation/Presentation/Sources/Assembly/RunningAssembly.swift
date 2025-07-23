//
//  RunningAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/23/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class RunningAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.autoregister(RunningReactor.self, initializer: RunningReactor.init)

    container.register(RunningCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return RunningCoordinatorImpl(navigationController: navigationController, resolver: r)
    }

    container.register(RunningViewController.self) { r in
      guard let reactor = r.resolve(RunningReactor.self) else {
        fatalError("Failed to resolve HomeReactor.")
      }
      let viewController = RunningViewController()
      viewController.reactor = reactor
      return viewController
    }

    container.register(FirstRunningOnboardingViewController.self) { r in
      let viewController = FirstRunningOnboardingViewController()
      return viewController
    }

    container.register(FirstRunningGoalSettingIntroViewController.self) { r in
      let viewController = FirstRunningGoalSettingIntroViewController()
      return viewController
    }

    container.register(FirstRunningGoalSettingViewController.self) { r in
      let viewController = FirstRunningGoalSettingViewController(inputType: .distance)
      return viewController
    }

    container.register(RunningPaceSettingViewController.self) { r in
      let viewController = RunningPaceSettingViewController()
      return viewController
    }
  }
}

