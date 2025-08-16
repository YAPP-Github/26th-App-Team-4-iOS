//
//  UserUseCase.swift
//  Domain
//
//  Created by JDeoks on 8/13/25.
//

import RxSwift

public protocol UserUseCase {
  func fetchMyUserInfo() -> Single<ProfileInfo>
  func saveRunnerType(runnerType: RunnerType) -> Single<Bool>
  func deleteAccount(reason: String) -> Single<Bool>
}

public final class UserUseCaseImpl: UserUseCase {
  
  private let userRepository: UserRepository
  
  public init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  public func fetchMyUserInfo() -> Single<ProfileInfo> {
    return userRepository.fetchUserInfo()
  }
  
  public func saveRunnerType(runnerType: RunnerType) -> Single<Bool> {
    return userRepository.saveRunnerType(type: runnerType)
  }
  
  public func deleteAccount(reason: String) -> Single<Bool> {
    return userRepository.deleteAccount(reason: reason)
  }
}
