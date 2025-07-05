//
//  LoginCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core

public protocol LoginCoordinatorDelegate: AnyObject {
  func didLoginSuccessfully()
}

public final class LoginCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .login
  public var finishDelegate: CoordinatorFinishDelegate?

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    let viewController = LoginViewController()
    viewController.coordinator = self
    viewController.reactor = LoginReactor()
    navigationController.pushViewController(viewController, animated: false)
  }
}

extension LoginCoordinator: LoginCoordinatorDelegate {
  public func didLoginSuccessfully() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
