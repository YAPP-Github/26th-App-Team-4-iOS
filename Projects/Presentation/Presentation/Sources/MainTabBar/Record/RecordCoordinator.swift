//
//  RecordCoordinator.swift
//  Presentation
//
//  Created by JDeoks on 7/30/25.
//

import UIKit
import Swinject
import Core

public protocol RecordCoordinator: Coordinator {
  /// 리스트에서 특정 기록 상세로 이동할 때 호출
  func showRecordDetail(recordID: Int)
}

public final class RecordCoordinatorImpl: RecordCoordinator {
  
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .record   // CoordinatorType에 .record 케이스가 있어야 합니다
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver
  
  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
  }
  
  /// 탭 선택 시 최초 진입화면 (기록 리스트)
  public func start() {
    guard let viewController = resolver.resolve(RecordListViewController.self) else {
      fatalError("Failed to resolve RecordListViewController. Ensure it is registered in Swinject.")
    }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: false)
  }
  
  /// 리스트에서 개별 기록 상세보기
  public func showRecordDetail(recordID: Int) {
    guard let viewController = resolver.resolve(
      RecordDetailViewController.self,
      argument: recordID
    ) else {
      fatalError("Failed to resolve RecordDetailViewController. Ensure it is registered in Swinject.")
    }
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - CoordinatorFinishDelegate
extension RecordCoordinatorImpl: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    // 필요에 따라 childCoordinators에서 제거
    childCoordinators.removeAll { $0 === childCoordinator }
  }
}
