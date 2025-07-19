//
//  HomeRepositoryImpl.swift
//  Data
//
//  Created by JDeoks on 7/19/25.
//

import Foundation
import Moya
import RxSwift

import Domain

public final class HomeRepositoryImpl: HomeRepository {
  
  private let provider: NetworkProvider<HomeAPI>
  
  /// 기본적으로 HomeAPI를 사용합니다.
  public init(provider: NetworkProvider<HomeAPI> = .init()) {
    self.provider = provider
  }
  
  public func fetchHomeData() -> Single<HomeInfo> {
    return provider
      .request(.home)
      .filter(statusCodes: 200..<300)
      .map(APIResponse<HomeDTO>.self)
      .map { response in
        guard let result = response.result else {
          throw RepositoryError.emptyData
        }
        return result.toDomain()
      }
      .asSingle()
  }
}

/// Repository 수준에서 발생할 수 있는 에러
public enum RepositoryError: Error {
  /// 서버 응답은 왔으나 `result`가 `nil`인 경우
  case emptyData
}
