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

  public init(moyaProvider: MoyaProvider<Target>) {
    self.moyaProvider = moyaProvider
  }

  public func request(_ target: Target) -> Observable<Moya.Response> {
    return moyaProvider.rx.request(target).asObservable()
  }
}
