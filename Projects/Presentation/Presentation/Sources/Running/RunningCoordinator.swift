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
  func showFirstRunningOnboarding()
  func showFirstRunningGoalSettingIntro()
  func showFirstRunningGoalSetting(goalInputType: GoalInputType)
  func showRunning()
  func showRunningResult()
  func showRunningPaceSetting()
  func dismissRunningFlow()
  func pop()
}

public final class RunningCoordinatorImpl: RunningCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .running
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver
  
  private var runningFlowNavigationController: UINavigationController!
  
  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }
  
  public func start() {
    showFirstRunningOnboarding()
  }
  
  public func dismissRunningFlow() {
    runningFlowNavigationController.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
  }
}

extension RunningCoordinatorImpl {
  public func showFirstRunningOnboarding() {
    guard let viewController = resolver.resolve(FirstRunningOnboardingViewController.self) else {
      fatalError("Failed to resolve FirstRunningOnboardingViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    runningFlowNavigationController = UINavigationController(rootViewController: viewController)
    runningFlowNavigationController.modalPresentationStyle = .fullScreen
    runningFlowNavigationController.isNavigationBarHidden = true
    
    navigationController.isNavigationBarHidden = true
    navigationController.present(runningFlowNavigationController, animated: false)
  }
  
  public func showFirstRunningGoalSettingIntro() {
    guard let viewController = resolver.resolve(FirstRunningGoalSettingIntroViewController.self) else {
      fatalError("Failed to resolve FirstRunningGoalSettingIntroViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    runningFlowNavigationController.pushViewController(viewController, animated: false)
  }
  
  public func showFirstRunningGoalSetting(goalInputType: GoalInputType) {
    guard let viewController = resolver.resolve(FirstRunningGoalSettingViewController.self, argument: goalInputType) else {
      fatalError("Failed to resolve FirstRunningGoalSettingViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    runningFlowNavigationController.pushViewController(viewController, animated: false)
  }
  
  public func showRunning() {
    guard let viewController = resolver.resolve(RunningViewController.self) else {
      fatalError("Failed to resolve RunningViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    runningFlowNavigationController.pushViewController(viewController, animated: false)
  }
  
  public func showRunningPaceSetting() {
    guard let viewController = resolver.resolve(RunningPaceSettingViewController.self) else {
      fatalError("Failed to resolve RunningViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self
    
    runningFlowNavigationController.pushViewController(viewController, animated: false)
  }
  
  public func showRunningResult() {
    // TODO: - 기록상세/러닝결과 coordinator 생성해서 분리하기
    guard let viewController = resolver.resolve(RecordDetailViewController.self) else {
      fatalError("Failed to resolve RecordDetailViewController. Ensure it is registered correctly in Swinject.")
    }
    viewController.coordinator = self

    runningFlowNavigationController.modalPresentationStyle = .none
    runningFlowNavigationController.pushViewController(viewController, animated: false)
  }

  public func pop() {
    runningFlowNavigationController.popViewController(animated: false)
  }
}
