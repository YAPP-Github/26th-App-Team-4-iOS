//
//  NetworkProvider.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import Moya
import RxMoya
import Domain

public final class NetworkProvider<Target: BaseAPI> {
  private let moyaProvider: MoyaProvider<Target>

  public init(
    plugins: [PluginType] = [
      // 기본 헤더나 인증 인터셉터 플러그인이 있다면 여기에,
      NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ]
  ) {
    self.moyaProvider = MoyaProvider<Target>(plugins: plugins)
  }

  public func request(_ target: Target) -> Observable<Moya.Response> {
    return moyaProvider.rx.request(target).asObservable()
  }
}
