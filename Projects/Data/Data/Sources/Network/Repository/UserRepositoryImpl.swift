//
//  UserRepositoryImpl.swift
//  Data
//
//  Created by JDeoks on 8/13/25.
//


import Foundation
import RxSwift
import Domain

public final class UserRepositoryImpl: UserRepository {
  
  private let provider: NetworkProvider<UserAPI>
  private let authTokenStorage = AuthTokenStorageImpl()
  
  public init(provider: NetworkProvider<UserAPI> = .init()) {
    self.provider = provider
  }
    
  public func fetchUserInfo() -> RxSwift.Single<Domain.ProfileInfo> {
    return provider.request(.fetchMyProfile)
      .filterSuccessfulStatusCodes()
      .map(APIResponse<ProfileInfoDTO>.self)
      .compactMap { $0.result?.toDomain() }
      .asSingle()
      .catch { error in
        // Handle the error appropriately, e.g., log it or convert it to a domain-specific error
        print("Error fetching user info: \(error)")
        return Single.error(error)
      }
  }
  
  public func saveRunnerType(type: RunnerType) -> Single<Bool> {
    return provider
      .request(.saveRunnerType(type: type.rawValue))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<OnboardingDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
  
  public func deleteAccount(reason: String) -> Single<Bool> {
    return provider
      .request(.deleteAccount(reason: reason))
        .map { _ in
          self.authTokenStorage.clearTokens()
          if let id = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: id)
            UserDefaults.standard.synchronize()
          }
          return true
        }
        .asSingle()
  }
  
  public func signOut() -> Single<Bool> {
    self.authTokenStorage.clearTokens()
    if let id = Bundle.main.bundleIdentifier {
      UserDefaults.standard.removePersistentDomain(forName: id)
      UserDefaults.standard.synchronize()
    }
    return .just(true)
  }
}
