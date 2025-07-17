//
//  AuthNetworkService.swift
//  Data
//
//  Created by dong eun shin on 7/12/25.
//

import Foundation
import Moya
import RxSwift
import Domain

public protocol AuthNetworkService {
  func requestAppleLogin(idToken: String) -> Single<LoginResultDTO>
  func requestKakaoLogin(idToken: String) -> Single<LoginResultDTO>
}

public final class AuthNetworkServiceImpl: AuthNetworkService {
  private let provider: MoyaProvider<AuthAPI>

  public init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
    self.provider = provider
  }

  public func requestAppleLogin(idToken: String) -> Single<LoginResultDTO> {
    return provider.rx.request(.appleLogin(idToken: idToken))
      .filterSuccessfulStatusCodes()
      .map(APIResponse<LoginResultDTO>.self)
      .flatMap { response in
        if response.code == "SUCCESS", let result = response.result {
          return .just(result)
        } else {
          return .error(NetworkError.serverError(message: "ERROR: requestAppleLogin"))
        }
      }
  }

  public func requestKakaoLogin(idToken: String) -> Single<LoginResultDTO> {
    return provider.rx.request(.kakaoLogin(idToken: idToken))
      .filterSuccessfulStatusCodes()
      .map(APIResponse<LoginResultDTO>.self)
      .flatMap { response in
        if response.code == "SUCCESS", let result = response.result {
          return .just(result)
        } else {
          return .error(NetworkError.serverError(message: "ERROR: requestKakaoLogin"))
        }
      }
  }

  // Custom Error
  public enum NetworkError: Error {
    case serverError(message: String)
    case decodingError
    case unknown
  }
}
