//
//  MyPageAssembly.swift
//  Presentation
//
//  Created by JDeoks on 8/11/25.
//

import UIKit
import Swinject
import SwinjectAutoregistration

public final class MyPageAssembly: Assembly {
  
  public init() {}
  
  public func assemble(container: Container) {
    container.register(MyPageCoordinator.self) { (r, navigationController: UINavigationController) in
      return MyPageCoordinatorImpl(navigationController: navigationController, resolver: r)
    }
//    container.register(RecordListReactor.self) { _ in
//      return RecordListReactor()
//    }
    container.register(MyPageViewController.self) { r in
//      guard let reactor = r.resolve(MyPageReactor.self) else {
//        fatalError("Failed to resolve RecordListReactor.")
//      }
      let vc = MyPageViewController()
//      vc.reactor = reactor
      return vc
    }
  }
}
