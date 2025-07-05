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
  private let resolver: Resolver
  private let disposeBag = DisposeBag()

  init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver

    navigationController.setNavigationBarHidden(true, animated: false)
  }

  func start() {
    showLaunchFlow()
  }

  private func showLaunchFlow() {
    let launchCoordinator = resolver.resolve(LaunchCoordinator.self, argument: navigationController)!
    launchCoordinator.delegate = self
    childCoordinators.append(launchCoordinator)
    launchCoordinator.start()
  }

  private func showWalkthroughFlow() {
    navigationController.viewControllers = []
    let walkthroughCoordinator = resolver.resolve(WalkthroughCoordinator.self, argument: navigationController)!
    walkthroughCoordinator.delegate = self
    childCoordinators.append(walkthroughCoordinator)
    walkthroughCoordinator.start()
  }

  private func showLoginFlow() {
    navigationController.viewControllers = []
    let loginCoordinator = resolver.resolve(LoginCoordinator.self, argument: navigationController)!
    loginCoordinator.delegate = self
    childCoordinators.append(loginCoordinator)
    loginCoordinator.start()
  }

  private func showOnboardingFlow() {
    navigationController.viewControllers = []
    let onboardingCoordinator = resolver.resolve(OnboardingCoordinator.self, argument: navigationController)!
    onboardingCoordinator.delegate = self
    childCoordinators.append(onboardingCoordinator)
    onboardingCoordinator.start()
  }

  private func showMainTabFlow() {
    navigationController.viewControllers = []
    let mainTabCoordinator = resolver.resolve(MainTabCoordinator.self, argument: navigationController)!
    childCoordinators.append(mainTabCoordinator)
    mainTabCoordinator.start()
    navigationController.setNavigationBarHidden(false, animated: true)
  }

  // MARK: - Session Expiration Handling
  private func setupSessionExpirationObserver() {

  }
}

// MARK: - LaunchCoordinatorDelegate
extension AppCoordinator: LaunchCoordinatorDelegate {
  func didFinishLaunch(with status: UserStatus, from coordinator: LaunchCoordinator) {
    removeChildCoordinator(coordinator)

    switch status {
    case .needsWalkthrough:
      showWalkthroughFlow()
    case .needsRegistrationOrLogin:
      showLoginFlow()
    case .needsOnboarding:
      showOnboardingFlow()
    case .loggedIn:
      showMainTabFlow()
    }
  }
}

// MARK: - WalkthroughCoordinatorDelegate
extension AppCoordinator: WalkthroughCoordinatorDelegate {
  func didCompleteWalkthrough(from coordinator: WalkthroughCoordinator) {
    removeChildCoordinator(coordinator)

    showLoginFlow()
  }
}

// MARK: - LoginCoordinatorDelegate
extension AppCoordinator: LoginCoordinatorDelegate {
  func didLoginSuccessfully(from coordinator: LoginCoordinator) {
    removeChildCoordinator(coordinator)

    // TODO: - 상태 확인 후 화면 전환
    self.showOnboardingFlow()
  }
}

// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
  func didCompleteOnboarding(from coordinator: OnboardingCoordinator) {
    removeChildCoordinator(coordinator)
    showMainTabFlow()
  }
}
