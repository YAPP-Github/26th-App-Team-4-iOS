//
//  RunningCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/23/25.
//

import UIKit
import Swinject
import RxSwift
import Core

public protocol RunningCoordinator: Coordinator {
  func showFirstRunningGoalSettingIntro()
  func showFirstRunningGoalSetting(goalInputType: GoalInputType)
  func showRunning()
  func showRunningResult(recordId: Int)
  func dismissRunningFlow()
  func pop()
}

public final class RunningCoordinatorImpl: RunningCoordinator, CoordinatorFinishDelegate {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .running
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  private var runningFlowNavigationController: UINavigationController?

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }

  public func start() {
    let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedRunningOnboarding")

    let rootViewController: UIViewController
    if hasCompletedOnboarding {
      guard let runningVC = resolver.resolve(RunningViewController.self) else {
        fatalError("Failed to resolve RunningViewController.")
      }
      runningVC.coordinator = self
      rootViewController = runningVC
    } else {
      guard let onboardingVC = resolver.resolve(FirstRunningOnboardingViewController.self) else {
        fatalError("Failed to resolve FirstRunningOnboardingViewController.")
      }
      onboardingVC.coordinator = self
      rootViewController = onboardingVC
    }

    runningFlowNavigationController = UINavigationController(rootViewController: rootViewController)
    runningFlowNavigationController?.modalPresentationStyle = .fullScreen
    runningFlowNavigationController?.isNavigationBarHidden = true

    navigationController.present(runningFlowNavigationController!, animated: false)
  }

  public func dismissRunningFlow() {
    runningFlowNavigationController?.dismiss(animated: false) { [weak self] in
      guard let self = self else { return }
      self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
  }
}

extension RunningCoordinatorImpl {
  public func showFirstRunningGoalSettingIntro() {
    guard let viewController = resolver.resolve(FirstRunningGoalSettingIntroViewController.self) else { return }
    viewController.coordinator = self
    runningFlowNavigationController?.pushViewController(viewController, animated: false)
  }

  public func showFirstRunningGoalSetting(goalInputType: GoalInputType) {
    guard let viewController = resolver.resolve(FirstRunningGoalSettingViewController.self, argument: goalInputType) else { return }
    viewController.coordinator = self
    runningFlowNavigationController?.pushViewController(viewController, animated: false)
  }

  public func showRunning() {
    guard let viewController = resolver.resolve(RunningViewController.self) else { return }
    viewController.coordinator = self
    runningFlowNavigationController?.pushViewController(viewController, animated: false)
  }

  public func showRunningResult(recordId: Int) {
    guard let navigationControllerForFlow = runningFlowNavigationController else {
      fatalError("runningFlowNavigationController is not set.")
    }
    guard let coordinator = resolver.resolve(RecordDetailCoordinatorImpl.self, arguments: navigationControllerForFlow, recordId) else {
      fatalError("Failed to resolve RecordDetailCoordinator. Ensure it is registered correctly in Swinject.")
    }
    coordinator.finishDelegate = self
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  public func pop() {
    runningFlowNavigationController?.popViewController(animated: false)
  }

  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    switch childCoordinator.type {
    case .recordDetail:
      dismissRunningFlow()
    default:
      return
    }
  }
}
