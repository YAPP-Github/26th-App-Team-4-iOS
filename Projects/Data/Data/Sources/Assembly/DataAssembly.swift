//
//  DataAssembly.swift
//  Data
//
//  Created by dong eun shin on 7/18/25.
//

import Swinject
import Domain
import Moya

public class DataAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    // Login
    container.register(MoyaProvider<AuthAPI>.self) { _ in
      return MoyaProvider<AuthAPI>()
    }

    container.register(AuthNetworkServiceImpl.self) { r in
      guard let provider = r.resolve(MoyaProvider<AuthAPI>.self) else {
        fatalError("Failed to resolve MoyaProvider<AuthAPI> for AuthNetworkServiceImpl.")
      }
      return AuthNetworkServiceImpl(provider: provider)
    }

    container.register(KakaoLoginServiceImpl.self) { r in
      return KakaoLoginServiceImpl()
    }

    container.autoregister(AuthTokenStorageImpl.self, initializer: AuthTokenStorageImpl.init)

    container.register(AuthRepository.self) { r in
      guard
        let kakaoLoginService = r.resolve(KakaoLoginServiceImpl.self),
        let networkService = r.resolve(AuthNetworkServiceImpl.self),
        let tokenStorage = r.resolve(AuthTokenStorageImpl.self)
      else {
        fatalError("Failed to resolve dependencies for AuthRepository.")
      }
      return AuthRepositoryImpl(kakaoLoginService: kakaoLoginService, networkService: networkService, tokenStorage: tokenStorage)
    }

    // Onboarding
    container.register(OnboardingRepository.self) { r in
      return OnboardingRepositoryImpl()
    }

    // Home
    container.register(HomeRepository.self) { r in
      return HomeRepositoryImpl()
    }
  }
}
