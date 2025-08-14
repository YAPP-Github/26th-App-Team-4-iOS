//
//  UserUseCase.swift
//  Domain
//
//  Created by JDeoks on 8/13/25.
//

import RxSwift

public protocol UserUseCase {
  func fetchMyUserInfo() -> Single<ProfileInfo>
}

public final class UserUseCaseImpl: UserUseCase {
  
  private let userRepository: UserRepository
  
  public init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  public func fetchMyUserInfo() -> Single<ProfileInfo> {
    return userRepository.fetchUserInfo()
  }

}
