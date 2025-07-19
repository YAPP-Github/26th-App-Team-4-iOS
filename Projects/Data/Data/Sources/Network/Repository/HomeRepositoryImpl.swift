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
          throw NSError(domain: "HomeRepositoryImpl", code: -1, userInfo: [NSLocalizedDescriptionKey: "No result found in response"])
        }
        return result.toDomain()
      }
      .asSingle()
  }
}
