//
//  LaunchAssembler.swift
//  Presentation
//
//  Created by dong eun shin on 7/5/25.
//

import Swinject

public final class LaunchAssembler: Assembly {
  public init() {}
  public func assemble(container: Container) {
    container.register(LaunchReactor.self) { r in
      LaunchReactor()
    }
    
    container.register(LaunchViewController.self) { (r, coordinator: LaunchCoordinator) in
      let reactor = r.resolve(LaunchReactor.self)!
      let viewController = LaunchViewController()
      viewController.reactor = reactor
      viewController.coordinator = coordinator
      return viewController
    }
  }
}
