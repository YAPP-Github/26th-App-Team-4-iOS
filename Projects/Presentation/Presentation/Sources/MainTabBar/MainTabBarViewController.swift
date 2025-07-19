//
//  MainTabBarViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

import UIKit
import ReactorKit
import Core

public final class MainTabBarViewController: BaseViewController, View {
  public typealias Reactor = MainTabBarReactor

  weak var coordinator: MainTabBarCoordinator?

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  public func bind(reactor: MainTabBarReactor) {

  }

  private func setupUI() {

  }
}
