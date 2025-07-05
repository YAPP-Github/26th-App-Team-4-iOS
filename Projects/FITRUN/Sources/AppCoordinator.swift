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

final class AppCoordinator: Coordinator {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorType = .app

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController

    navigationController.setNavigationBarHidden(true, animated: false)
  }

  func start() {
    showLaunchFlow()
  }

  private func showLaunchFlow() {
    let coordinator = LaunchCoordinator(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  private func showWalkthroughFlow() {
    let coordinator = WalkthroughCoordinator(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  private func showLoginFlow() {
    let coordinator = LoginCoordinator(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  private func showOnboardingFlow() {
    let coordinator = OnboardingCoordinator(navigationController: navigationController)
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  private func showMainTabFlow() {

  }
}

// MARK: - CoordinatorFinishDelegate
extension AppCoordinator: CoordinatorFinishDelegate {
  func coordinatorDidFinish(childCoordinator: Coordinator) {
    childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

    switch childCoordinator.type {
    case .app:
      childCoordinators.removeAll()
      navigationController.viewControllers.removeAll()

      showLaunchFlow()
    case .launchScreen:
      childCoordinators.removeAll()
      navigationController.viewControllers.removeAll()

      showWalkthroughFlow()
    case .walkthrough:
      childCoordinators.removeAll()
      navigationController.viewControllers.removeAll()

      showLoginFlow()
    case .login:
      childCoordinators.removeAll()
      navigationController.viewControllers.removeAll()

      showOnboardingFlow()
    case .onboarding:
      childCoordinators.removeAll()
      navigationController.viewControllers.removeAll()

      showMainTabFlow()
    default:
      break
    }
  }
}
