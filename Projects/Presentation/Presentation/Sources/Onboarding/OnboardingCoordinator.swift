//
//  OnboardingCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol OnboardingCoordinatorDelegate: AnyObject {
  func didCompleteOnboarding(from coordinator: OnboardingCoordinator)
}

public final class OnboardingCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .onboarding
  public var finishDelegate: CoordinatorFinishDelegate?
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    let viewController = OnboardingViewController()
    viewController.coordinator = self
    viewController.reactor = OnboardingReactor()
    navigationController.pushViewController(viewController, animated: false)
  }
}
