//
//  HomeCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/23/25.
//

import UIKit
import Swinject
import RxSwift
import Core

public protocol HomeCoordinator: Coordinator {
  func showRunngingFlow()
}

public final class HomeCoordinatorImpl: HomeCoordinator {

  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .home
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    guard let viewController = resolver.resolve(HomeViewController.self) else {
      fatalError("Failed to resolve HomeViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    navigationController.pushViewController(viewController, animated: false)
  }
}

extension HomeCoordinatorImpl {
  public func showRunngingFlow() {
    guard let coordinator = resolver.resolve(RunningCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve MainTabBarCoordinatorImpl. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}

extension HomeCoordinatorImpl: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: any Coordinator) {

  }
}
