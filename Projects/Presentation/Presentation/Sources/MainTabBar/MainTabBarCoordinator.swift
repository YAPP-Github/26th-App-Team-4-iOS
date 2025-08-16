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
  case myPage

  var pageTitle: String {
    switch self {
    case .home:   return "홈"
    case .record: return "기록"
    case .myPage: return "마이페이지"
    }
  }

  var pageImage: UIImage? {
    switch self {
    case .home:
      return UIImage(named: "home", in: .module, with: nil)?
        .resized(to: CGSize(width: 24, height: 24))?
        .withRenderingMode(.alwaysTemplate) // ← 템플릿 처리
    case .record:
      return UIImage(named: "chart", in: .module, with: nil)?
        .resized(to: CGSize(width: 24, height: 24))?
        .withRenderingMode(.alwaysTemplate) // ← 템플릿 처리
    case .myPage:
      return UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate) // ← 템플릿 처리
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

    // MARK: - Tab bar appearance (selected/normal tint)
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white

    let selectedIcon = FRColor.Fg.Icon.primary
    let normalIcon   = UIColor(hex: "#C2C6CE")
    let selectedText = FRColor.Fg.Text.primary
    let normalText   = FRColor.Fg.Text.secondary

    func configureItemAppearance(_ item: UITabBarItemAppearance) {
      item.selected.iconColor = selectedIcon
      item.normal.iconColor   = normalIcon
      item.selected.titleTextAttributes = [.foregroundColor: selectedText]
      item.normal.titleTextAttributes   = [.foregroundColor: normalText]
    }

    configureItemAppearance(appearance.stackedLayoutAppearance)
    configureItemAppearance(appearance.inlineLayoutAppearance)
    configureItemAppearance(appearance.compactInlineLayoutAppearance)

    tabBarController.tabBar.standardAppearance   = appearance
    tabBarController.tabBar.scrollEdgeAppearance = appearance

    // 백업 틴트 (템플릿 이미지용)
    tabBarController.tabBar.tintColor = selectedIcon
    tabBarController.tabBar.unselectedItemTintColor = normalIcon
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

    // 이미지는 템플릿 렌더링을 가정(pageImage가 이미 .alwaysTemplate)
    navController.tabBarItem = UITabBarItem(
      title: page.pageTitle,
      image: page.pageImage,
      tag: page.rawValue
    )

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

    case .myPage:
      guard let coordinator = resolver.resolve(MyPageCoordinator.self, argument: navController) else {
        fatalError("Failed to resolve MyPageCoordinator. Ensure it is registered correctly in Swinject.")
      }
      coordinator.finishDelegate = self
      childCoordinators.append(coordinator)
      coordinator.start()
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
    self.childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

    if childCoordinator.type == .myPage {
      navigationController.dismiss(animated: false)
      finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
  }
}
