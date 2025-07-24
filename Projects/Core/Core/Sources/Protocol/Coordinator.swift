//
//  Coordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit

public protocol CoordinatorFinishDelegate: AnyObject {
  func coordinatorDidFinish(childCoordinator: Coordinator)
}

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  var type: CoordinatorType { get }
  var finishDelegate: CoordinatorFinishDelegate? { get set }

  func start()
}

extension Coordinator {
  func finish() {
    childCoordinators.removeAll()
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}

public enum CoordinatorType {
  case app
  case launchScreen
  case walkthrough
  case login
  case onboarding
  case mainTabBar
  case home
  case running
}

public protocol AppCoordinator: Coordinator {
  func showWalkthrough()
  func showLogin()
  func showOnboarding()
  func showMainTab()
}
