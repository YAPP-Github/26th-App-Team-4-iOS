//
//  LoginAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/18/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class LoginAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.autoregister(LoginReactor.self, initializer: LoginReactor.init)

    container.register(LoginCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return LoginCoordinatorImpl(navigationController: navigationController, resolver: r)
    }

    container.register(LoginViewController.self) { r in
      guard let reactor = r.resolve(LoginReactor.self) else {
        fatalError("Failed to resolve LoginReactor. Ensure LoginReactor is registered correctly.")
      }
      let viewController = LoginViewController()
      viewController.reactor = reactor
      return viewController
    }
  }
}
