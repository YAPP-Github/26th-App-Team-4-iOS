//
//  PaceSettingCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 8/13/25.
//

import UIKit
import Swinject
import Core

public protocol PaceSettingCoordinator: Coordinator {
  func pop()
}

public final class PaceSettingCoordinatorImpl: PaceSettingCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .paceSetting
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    guard let viewController = resolver.resolve(RunningPaceSettingViewController.self) else { return }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: false)
  }
}

extension PaceSettingCoordinatorImpl {
  public func pop() {
    navigationController.popViewController(animated: false)
  }
}
