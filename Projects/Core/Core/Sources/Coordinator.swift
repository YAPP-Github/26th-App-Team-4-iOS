//
//  Coordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var children: [Coordinator] { get set }

  func start()
  func finish()
}

extension Coordinator {
  func finish() {
    children.removeAll()
  }
}
