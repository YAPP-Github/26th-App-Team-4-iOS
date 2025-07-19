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

  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  public func execute() -> Single<UserStatus> {
    return authRepository.hasValidAuthSession()
      .flatMap { [weak self] hasSession -> Single<UserStatus> in
        guard let self else { return .just(.needsWalkthrough) }
        if hasSession {
          // TODO: 온보딩 완료 여부 등 추가 비즈니스 정책 확인
          // let hasCompletedOnboarding = self.userDefaultsRepository.getBool(forKey: .hasCompletedOnboarding) ?? false
          // if hasCompletedOnboarding {
          //     return .just(.loggedIn)
          // } else {
          //     return .just(.needsWalkthrough)
          // }

          return .just(.loggedIn)
        } else {
          // TODO: 앱 최초 실행/온보딩 완료 여부 확인
          // let isFirstLaunch = self.userDefaultsRepository.getBool(forKey: .isFirstLaunch) ?? true
          // if isFirstLaunch {
          //     return .just(.needsWalkthrough)
          // } else {
          //     return .just(.needsLogin)
          // }
          return .just(.needsWalkthrough)
        }
      }
      .catch { error in
        print("CheckLoginStatusUseCase error: \(error.localizedDescription)")
        return .just(.needsWalkthrough)
      }
  }
}
