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
}

public final class LoginCoordinatorImpl {
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
    //    viewController.reactor = container.resolve(LoginReactor.self)

    navigationController.pushViewController(viewController, animated: false)
  }
}

extension LoginCoordinatorImpl: LoginCoordinator {
  public func showOnboarding() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
