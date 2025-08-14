//
//  LoginCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol LoginCoordinator: Coordinator {
  func showOnboarding()
  func showMainTabbar()
}

public final class LoginCoordinatorImpl: LoginCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .login
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    guard let viewController = resolver.resolve(LoginViewController.self) else {
      fatalError("Failed to resolve LoginViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    navigationController.setViewControllers([viewController], animated: false)
  }
}

extension LoginCoordinatorImpl {
  public func showOnboarding() {
    guard let coordinator = resolver.resolve(OnboardingCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve OnboardingCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  public func showMainTabbar() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}

extension LoginCoordinatorImpl: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: any Coordinator) {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
