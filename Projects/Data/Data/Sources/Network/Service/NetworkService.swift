//
//  NetworkService.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import Moya
import RxMoya
import Domain

public protocol NetworkServiceType {
  func request<T: BaseAPI>(_ target: T) -> Observable<Data>
  func request<T: BaseAPI, D: Codable>(_ target: T, responseType: D.Type) -> Observable<D>
}

public final class NetworkService: NetworkServiceType {
  // 이제 각 API 타입별 MoyaProvider를 직접 가집니다.
  private let authMoyaProvider: MoyaProvider<AuthAPI>
  private let userMoyaProvider: MoyaProvider<UserAPI>
  // 다른 API 타입이 있다면 추가

  public init(authInterceptor: AuthInterceptor) {
    // 모든 MoyaProvider에 공통 플러그인을 주입합니다.
    let commonPlugins: [PluginType] = [NetworkLoggerPlugin(), authInterceptor]

    // 각 MoyaProvider를 초기화합니다.
    self.authMoyaProvider = MoyaProvider<AuthAPI>(plugins: commonPlugins)
    self.userMoyaProvider = MoyaProvider<UserAPI>(plugins: commonPlugins)
  }

  public func request<T: BaseAPI>(_ target: T) -> Observable<Data> {
    let moyaProvider: MoyaProvider<T> // 요청할 TargetType에 맞는 Provider 선택

    // Target 타입에 따라 올바른 MoyaProvider를 선택합니다.
    // 이 부분은 컴파일러가 타입 추론을 할 수 있도록 `as!` 캐스팅을 사용합니다.
    // 실제 앱에서는 더 견고한 방법 (예: enum으로 API 그룹화)을 고려할 수 있습니다.
    if let authTarget = target as? AuthAPI {
      moyaProvider = authMoyaProvider as! MoyaProvider<T>
    } else if let userTarget = target as? UserAPI {
      moyaProvider = userMoyaProvider as! MoyaProvider<T>
    } else {
      // 정의되지 않은 API 타입에 대한 오류 처리
      return .error(NetworkError.unknown)
    }

    // Moya 요청을 실행하고 Observable<Data>로 변환하여 반환합니다.
    // 401 재시도, 상세 에러 매핑 등은 여기서 하지 않습니다.
    return moyaProvider.rx.request(target)
      .asObservable()
      .map { $0.data } // Moya.Response에서 Data만 추출
      .catch { error in
        // MoyaError를 NetworkError로 매핑하는 기본적인 로직 (선택적)
        if let moyaError = error as? MoyaError {
          switch moyaError {
          case .statusCode(let response):
            if response.statusCode == 401 {
              return .error(NetworkError.unauthorized)
            } else if (400..<500).contains(response.statusCode) {
              return .error(NetworkError.badRequest)
            } else if (500..<600).contains(response.statusCode) {
              return .error(NetworkError.serverError(statusCode: response.statusCode))
            }
          case .underlying(let underlyingError, _):
            if (underlyingError as NSError).code == NSURLErrorNotConnectedToInternet {
              return .error(NetworkError.noInternetConnection)
            }
          default:
            break
          }
        }
        return .error(NetworkError.unknown)
      }
  }

  // MARK: - request (decodes Data to Codable Type D)
  public func request<T: BaseAPI, D: Codable>(_ target: T, responseType: D.Type) -> Observable<D> {
    // 이미 Observable<Data>를 반환하는 다른 request 메서드를 호출합니다.
    return request(target)
      .flatMap { data -> Observable<D> in
        let decoder = JSONDecoder()
        do {
          let decodedObject = try decoder.decode(D.self, from: data)
          return .just(decodedObject)
        } catch {
          print("NetworkService: Decoding error for target \(target.path): \(error.localizedDescription)")
          return .error(NetworkError.decodingError(error))
        }
      }
  }
}
