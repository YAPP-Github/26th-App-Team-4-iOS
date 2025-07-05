//
//  MainTabBarViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

import UIKit
import Core

public final class MainTabBarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.tabBar.tintColor = DesignSystem.Colors.primary
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = DesignSystem.Colors.background
    }

    private func setupTabs() {
        // 실제 앱에서는 각 탭에 해당하는 Root ViewController를 설정합니다.
        // 이 VC들은 각각의 Feature Coordinator가 관리하게 됩니다.
        let homeVC = UIViewController() // Placeholder
        homeVC.view.backgroundColor = .systemRed
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let searchVC = UIViewController() // Placeholder
        searchVC.view.backgroundColor = .systemBlue
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let myPageVC = UIViewController() // Placeholder
        myPageVC.view.backgroundColor = .systemGreen
        myPageVC.tabBarItem = UITabBarItem(title: "My Page", image: UIImage(systemName: "person"), tag: 2)

        viewControllers = [homeVC, searchVC, myPageVC]
    }
}
