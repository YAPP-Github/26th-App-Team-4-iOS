//
//  DomainAssembly.swift
//  Domain
//
//  Created by dong eun shin on 7/18/25.
//

import Swinject
import SwinjectAutoregistration

public class DomainAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    container.register(AuthUseCase.self) { r in
      guard let authRepository = r.resolve(AuthRepository.self) else {
        fatalError("Failed to resolve AuthRepository for AuthUseCase.")
      }
      return AuthUseCaseImpl(authRepository: authRepository)
    }

    container.register(OnboardingUseCase.self) { r in
      guard let repository = r.resolve(OnboardingRepository.self) else {
        fatalError("Failed to resolve OnboardingRepository for OnboardingUseCase.")
      }
      return OnboardingUseCaseImpl(repository: repository)
    }

    container.register(CheckLoginStatusUseCase.self) { r in
      guard let repository = r.resolve(AuthRepository.self) else {
        fatalError("Failed to resolve AuthRepository for CheckLoginStatusUseCase.")
      }
      return CheckLoginStatusUseCaseImpl(authRepository: repository)
    }
  }
}
