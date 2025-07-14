//
//  OnboardingCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core
import Domain
import Data

public protocol OnboardingCoordinator: Coordinator {
  func showMainTab()
}

public final class OnboardingCoordinatorImpl {
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
    viewController.reactor = OnboardingReactor(saveOnboardingUseCase: SaveOnboardingUseCaseImpl(repository: OnboardingRepositoryImpl()))
    navigationController.pushViewController(viewController, animated: false)
  }
}

extension OnboardingCoordinatorImpl: OnboardingCoordinator {
  public func showMainTab() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
