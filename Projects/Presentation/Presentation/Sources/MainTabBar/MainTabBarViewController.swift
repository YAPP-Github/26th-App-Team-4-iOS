//
//  MainTabBarViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/3/25.
//

import UIKit
import Core
import Domain
import Data

public final class MainTabBarController: UITabBarController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
  }
  
  private func setupTabs() {
    let homeVC = HomeViewController().then {
      $0.reactor = HomeReactor(
        homeUseCase: HomeUseCaseImpl(homeRepository: HomeRepositoryImpl())
      )
    }
    
    let homeNav = UINavigationController(rootViewController: homeVC)
    
    homeNav.tabBarItem = UITabBarItem(
      title: "홈",
      image: UIImage(systemName: "house"),
      selectedImage: UIImage(systemName: "house")
    )
    
    viewControllers = [
      homeNav
    ]
    
    tabBar.tintColor = .black
    tabBar.unselectedItemTintColor = .gray
    tabBar.backgroundColor = .white//.mainBackground
    tabBar.isTranslucent = false

//    tabBar.layer.shadowColor = UIColor.black.cgColor
//    tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
//    tabBar.layer.shadowRadius = 3
//    tabBar.layer.shadowOpacity = 0.2
//    tabBar.layer.masksToBounds = false
//    tabBar.shadowImage = UIImage()
    
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithTransparentBackground()
    tabBar.standardAppearance = tabBarAppearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = tabBarAppearance
    }
  }
}
