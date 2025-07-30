//
//  OnboardingCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol OnboardingCoordinator: Coordinator {
  func showMainTab()
  func showRunnerType()
}

public final class OnboardingCoordinatorImpl: OnboardingCoordinator {
  
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .onboarding
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
//    guard let viewController = resolver.resolve(OnboardingViewController.self) else {
//      fatalError("Failed to resolve OnboardingViewController. Ensure it is registered correctly in Swinject.")
//    }
//    viewController.coordinator = self
//
//    navigationController.setViewControllers([viewController], animated: false)
    guard let viewController = resolver.resolve(RunnerTypeViewController.self) else {
      fatalError("Failed to resolve OnboardingViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self

    navigationController.setViewControllers([viewController], animated: false)
  }
}

extension OnboardingCoordinatorImpl {
  public func showMainTab() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }

  public func showRunnerType() {
    guard let viewController = resolver.resolve(RunnerTypeViewController.self) else {
      fatalError("Failed to resolve OnboardingViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self

    navigationController.pushViewController(viewController, animated: false)
  }
}
