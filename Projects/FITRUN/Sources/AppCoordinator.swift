//
//  AppCoordinator.swift
//  FITRUN
//
//  Created by dong eun shin on 7/4/25.
//  Copyright © 2025 com.yapp. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import Domain
import Presentation
import Core

final class AppCoordinatorImpl {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorType = .app
  weak var finishDelegate: CoordinatorFinishDelegate?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController

    navigationController.setNavigationBarHidden(true, animated: false)
  }

  func start() {
    showLaunch()
  }
}

extension AppCoordinatorImpl: AppCoordinator {
  func showLaunch() {
    let coordinator = LaunchCoordinatorImpl(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showWalkthrough() {
    self.navigationController.viewControllers.removeAll()

    let coordinator = WalkthroughCoordinatorImpl(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showLogin() {
    self.navigationController.viewControllers.removeAll()

    let coordinator = LoginCoordinatorImpl(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showOnboarding() {
    self.navigationController.viewControllers.removeAll()

    let coordinator = OnboardingCoordinatorImpl(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showMainTab() {
    self.navigationController.viewControllers.removeAll()

    let coordinator = MainTabBarCoordinator(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}

// MARK: - CoordinatorFinishDelegate
extension AppCoordinatorImpl: CoordinatorFinishDelegate {
  func coordinatorDidFinish(childCoordinator: Coordinator) {
    childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

    switch childCoordinator.type {
    case .app:
      showLaunch()
    case .launchScreen:
      showWalkthrough()
    case .walkthrough:
      showLogin()
    case .login:
      showOnboarding()
    case .onboarding:
      showMainTab()
    default:
      break
    }
  }
}
