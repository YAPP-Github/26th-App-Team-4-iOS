//
//  PresentationAssembly.swift
//  Presentation
//
//  Created by dong eun shin on 7/18/25.
//

import Swinject

public class PresentationAssembly: Assembly {
  public init() {}
  
  public func assemble(container: Container) {
    LaunchAssembly().assemble(container: container)
    LoginAssembly().assemble(container: container)
    OnboardingAssembly().assemble(container: container)
    WalkthroughAssembly().assemble(container: container)
    MainTabBarAssembly().assemble(container: container)
    RunningAssembly().assemble(container: container)
  }
}
