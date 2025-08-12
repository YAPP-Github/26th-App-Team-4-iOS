//
//  CheckLoginStatusUseCase.swift
//  Domain
//
//  Created by dong eun shin on 7/20/25.
//

import Foundation
import RxSwift

public protocol CheckLoginStatusUseCase {
  func execute() -> Single<UserStatus>
}

public final class CheckLoginStatusUseCaseImpl: CheckLoginStatusUseCase {
  private let authRepository: AuthRepository
  private let userDefaults: UserDefaults

  public init(authRepository: AuthRepository, userDefaults: UserDefaults = .standard) {
    self.authRepository = authRepository
    self.userDefaults = userDefaults
  }

  public func execute() -> Single<UserStatus> {
    return authRepository.attemptAutoLogin()
      .map { _ in
        let hasCompletedOnboarding = self.userDefaults.bool(forKey: "hasCompletedOnboarding") == true
        return hasCompletedOnboarding ? .loggedIn : .needsWalkthrough
      }
      .catch { _ in
        let isFirstLaunch = self.userDefaults.bool(forKey: "isFirstLaunch") != false
        return .just(isFirstLaunch ? .needsWalkthrough : .needsLogin)
      }
  }
}
