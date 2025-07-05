//
//  WalkthroughCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol WalkthroughCoordinatorDelegate: AnyObject {
  func didCompleteWalkthrough()
}

public final class WalkthroughCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: Core.CoordinatorType = .walkthrough
  public var finishDelegate: CoordinatorFinishDelegate?
  public weak var delegate: WalkthroughCoordinatorDelegate?

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    let viewController = WalkthroughViewController()
    viewController.coordinator = self
    viewController.reactor = WalkthroughReactor()
    navigationController.setViewControllers([viewController], animated: true)
  }
}

extension WalkthroughCoordinator: WalkthroughCoordinatorDelegate {
  public func didCompleteWalkthrough() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
