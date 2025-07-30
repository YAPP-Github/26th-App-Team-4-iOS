//
//  MainTabBarCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject
import Core


enum TabBarPage: Int, CaseIterable {
  case home = 0
  case record

  var pageTitle: String {
    switch self {
    case .home: return "홈"
    case .record: return "기록"
    }
  }

  var pageImage: UIImage? {
    switch self {
    case .home: return UIImage(systemName: "house.fill")
    case .record: return UIImage(systemName: "list.bullet")
    }
  }
}

protocol MainTabBarCoordinator: Coordinator {
  func selectPage(_ page: TabBarPage)
  func setSelectedIndex(_ index: Int)
  func currentPage() -> TabBarPage?
}

public class MainTabBarCoordinatorImpl: NSObject, MainTabBarCoordinator {

  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  public var type: CoordinatorType = .mainTabBar
  public var tabBarController: UITabBarController

  public weak var finishDelegate: CoordinatorFinishDelegate?
  private let resolver: Resolver

  public init(navigationController: UINavigationController, resolver: Resolver) {
    self.navigationController = navigationController
    self.resolver = resolver
    self.tabBarController = UITabBarController()
    super.init()
    self.tabBarController.delegate = self

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white

    appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]

    tabBarController.tabBar.standardAppearance = appearance
    tabBarController.tabBar.scrollEdgeAppearance = appearance
  }

  public func start() {
    let pages: [TabBarPage] = TabBarPage.allCases
    let controllers = pages.map { getTabController($0) }

    tabBarController.setViewControllers(controllers, animated: false)
    tabBarController.modalPresentationStyle = .fullScreen
    navigationController.present(tabBarController, animated: false)
  }

  private func getTabController(_ page: TabBarPage) -> UINavigationController {
    let navController = UINavigationController()
    navController.tabBarItem = UITabBarItem(title: page.pageTitle, image: page.pageImage, tag: page.rawValue)

    switch page {
    case .home:
      guard let coordinator = resolver.resolve(HomeCoordinatorImpl.self, argument: navController) else {
        fatalError("Failed to resolve HomeCoordinator. Ensure it is registered correctly in Swinject.")
      }

      coordinator.finishDelegate = self
      childCoordinators.append(coordinator)
      coordinator.start()
      
    case .record:
      let recordCoord = resolver.resolve(RecordCoordinatorImpl.self, argument: navController)!
      recordCoord.finishDelegate = self
      childCoordinators.append(recordCoord)
      recordCoord.start()
    }
    return navController
  }

  func selectPage(_ page: TabBarPage) {
    tabBarController.selectedIndex = page.rawValue
  }

  func setSelectedIndex(_ index: Int) {
    tabBarController.selectedIndex = index
  }

  func currentPage() -> TabBarPage? {
    TabBarPage(rawValue: tabBarController.selectedIndex)
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarCoordinatorImpl: UITabBarControllerDelegate {
  public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if let selectedNavController = viewController as? UINavigationController {
      if let index = tabBarController.viewControllers?.firstIndex(of: selectedNavController),
         let page = TabBarPage(rawValue: index) {
        print("Selected tab: \(page.pageTitle)")
      }
    }
  }
}

extension MainTabBarCoordinatorImpl: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    removeChildCoordinator(childCoordinator)
  }
}
