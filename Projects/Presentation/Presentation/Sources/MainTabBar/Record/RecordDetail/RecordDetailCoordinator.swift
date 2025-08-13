//
//  RecordDetailCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 8/13/25.
//

import UIKit
import Swinject
import Core

public protocol RecordDetailCoordinator: Coordinator {
  func pop()
  func showRunningPaceSetting()
}

public final class RecordDetailCoordinatorImpl: RecordDetailCoordinator, CoordinatorFinishDelegate {
  
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .recordDetail
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver
  private let recordID: Int

  public init(recordID: Int, navigationController: UINavigationController, resolver: Resolver) {
    self.recordID = recordID
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    guard let viewController = resolver.resolve(RecordDetailViewController.self, argument: recordID) else {
      fatalError("Failed to resolve RecordDetailViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self

    navigationController.pushViewController(viewController, animated: false)
  }
}

extension RecordDetailCoordinatorImpl {
  public func pop() {
    navigationController.popViewController(animated: false)
  }

  public func showRunningPaceSetting() {
    guard let coordinator = resolver.resolve(PaceSettingCoordinatorImpl.self, argument: navigationController) else {
      fatalError("Failed to resolve RecordDetailCoordinator. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    if childCoordinator.type == .paceSetting {
      pop()
    } else {
      finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
  }
}
