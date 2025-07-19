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
import Presentation
import Core

final class AppCoordinatorImpl {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorType = .app
  weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver

    navigationController.setNavigationBarHidden(true, animated: false)
  }

  func start() {
    showLaunch()
  }
}

extension AppCoordinatorImpl: AppCoordinator {
  func showLaunch() {
    guard let coordinator = resolver.resolve(LaunchCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve LaunchCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showWalkthrough() {
    self.navigationController.viewControllers.removeAll()

    guard let coordinator = resolver.resolve(WalkthroughCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve WalkthroughCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showLogin() {
    self.navigationController.viewControllers.removeAll()

    guard let coordinator = resolver.resolve(LoginCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve LoginCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showOnboarding() {
    self.navigationController.viewControllers.removeAll()

    guard let coordinator = resolver.resolve(OnboardingCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve OnboardingCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showMainTab() {
    self.navigationController.viewControllers.removeAll()

    guard let coordinator = resolver.resolve(MainTabBarCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve MainTabBarCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
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
