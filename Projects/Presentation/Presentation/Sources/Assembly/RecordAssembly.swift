//
//  RecordAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/5/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class RecordAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.autoregister(RecordListReactor.self, initializer: RecordListReactor.init)

    container.register(RecordCoordinatorImpl.self) { (r, navigationController: UINavigationController) in
      return RecordCoordinatorImpl(navigationController: navigationController, resolver: r)
    }

    container.register(RecordListViewController.self) { r in
      guard let reactor = r.resolve(RecordListReactor.self) else {
        fatalError("Failed to resolve LaunchReactor. Ensure LaunchReactor is registered correctly.")
      }
      let viewController = RecordListViewController()
      viewController.reactor = reactor
      return viewController
    }

    // Record Detail
    container.autoregister(
      RecordDetailReactor.self,
      argument: Int.self,
      initializer: RecordDetailReactor.init
    )

    container.register(RecordDetailCoordinatorImpl.self) { (r, navigationController: UINavigationController, recordId: Int) in
      return RecordDetailCoordinatorImpl(recordID: recordId, navigationController: navigationController, resolver: r)
    }

    container.register(RecordDetailViewController.self) { (r, recordId: Int) in
      guard let reactor = r.resolve(RecordDetailReactor.self, argument: recordId) else {
        fatalError("Failed to resolve RecordDetailReactor.")
      }
      let viewController = RecordDetailViewController()
      viewController.reactor = reactor
      return viewController
    }
  }
}
