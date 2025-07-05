//
//  AppleLoginRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on 6/26/25.
//

import Foundation
import Domain
import AuthenticationServices

public protocol LoginRepository {
  func saveUserID(_ id: String)
}

public final class LoginRepositoryImpl: LoginRepository {
  public init() {}

  public func saveUserID(_ id: String) {
    UserDefaults.standard.set(id, forKey: "user_id")
  }
}

//import Foundation
//import RxSwift
//import Moya
//import RxMoya
//import Domain
//
//public final class DefaultLoginRepository: LoginRepository {
//  private let provider: MoyaProvider<LoginAPI>
//
//  public init(provider: MoyaProvider<LoginAPI> = MoyaProvider<LoginAPI>()) {
//    self.provider = provider
//  }
//
//  public func login(with token: String) -> Single<User> {
//    return provider.rx.request(.socialLogin(token: token))
//      .filterSuccessfulStatusCodes()
//      .map(UserResponse.self)
//      .map { $0.result }
//  }
//}
