//
//  LoginCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core
import Domain
import Data

public protocol LoginCoordinator: Coordinator {
  func showOnboarding()
}

public final class LoginCoordinatorImpl {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .login
  public weak var finishDelegate: CoordinatorFinishDelegate?


  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    let viewController = LoginViewController()
    viewController.coordinator = self
    viewController.reactor = LoginReactor(authUseCase: AuthUseCaseImpl(authRepository: AuthRepositoryImpl(networkService: AuthNetworkService(), tokenStorage: AuthTokenStorage())))
    // TODO: - resolve
    //container.resolve(LoginReactor.self)

    navigationController.pushViewController(viewController, animated: false)
  }
}

extension LoginCoordinatorImpl: LoginCoordinator {
  public func showOnboarding() {
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
}
