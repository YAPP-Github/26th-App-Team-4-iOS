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

  func start()
}

extension Coordinator {
  func finish() {
    childCoordinators.removeAll()
  }
}

public enum CoordinatorType {
  case app
  case launchScreen
  case walkthrough
  case login
  case onboarding
  case mainTabBar
}
