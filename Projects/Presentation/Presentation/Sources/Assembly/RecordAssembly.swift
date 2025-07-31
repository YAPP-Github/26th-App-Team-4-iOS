//
//  RecordAssembly.swift
//  Presentation
//
//  Created by JDeoks on 7/30/25.
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
  }
}
