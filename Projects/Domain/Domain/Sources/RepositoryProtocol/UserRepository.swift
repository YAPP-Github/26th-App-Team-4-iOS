//
//  UserRepository.swift
//  Domain
//
//  Created by JDeoks on 8/13/25.
//

import RxSwift

public protocol UserRepository {
  func fetchUserInfo() -> Single<ProfileInfo>
  func saveRunnerType(type: RunnerType) -> Single<Bool>
  func deleteAccount(reason: String) -> Single<Bool>
}

