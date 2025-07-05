//
//  MainTabCoordinator.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import Swinject

public final class MainTabCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    private let resolver: Resolver

    public init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    public func start() {
        // 메인 탭바 컨트롤러 생성
        let mainTabBarController = MainTabBarController()
        // 각 탭의 Root Coordinator를 생성하고 childCoordinators에 추가 (예: HomeCoordinator, MyPageCoordinator 등)
        // 각 탭도 독립적인 Coordinator를 가질 수 있습니다.

        // 예시: 첫 번째 탭 (Home)
        let homeNav = UINavigationController()
        // let homeCoordinator = resolver.resolve(HomeCoordinator.self, argument: homeNav)!
        // homeCoordinator.start()
        // childCoordinators.append(homeCoordinator)

        // mainTabBarController.viewControllers = [homeNav, ...]

        navigationController.setViewControllers([mainTabBarController], animated: true)
    }
}
// MainTabBarController는 간단히 UITabBarController를 상속.
