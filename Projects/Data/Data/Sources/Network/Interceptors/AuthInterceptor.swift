//
//  AuthInterceptor.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import Moya
import RxSwift
import RxMoya
import Domain

public protocol TokenStorageType: AnyObject {
  func getAccessToken() -> String?
  func getRefreshToken() -> String?
  func saveTokens(accessToken: String, refreshToken: String)
  func clearTokens()
}

public class MockTokenStorage: TokenStorageType {
  public init() { // <--- Add 'public' here
    // Your existing initialization logic
  }
  private var accessToken: String? = "mock_access_token"
  private var refreshToken: String? = "mock_refresh_token"

  public func getAccessToken() -> String? { return accessToken }
  public func getRefreshToken() -> String? { return refreshToken }
  public func saveTokens(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    print("Tokens saved: Access=\(accessToken), Refresh=\(refreshToken)")
  }
  public func clearTokens() {
    self.accessToken = nil
    self.refreshToken = nil
    print("Tokens cleared.")
  }
}

// MARK: - RefreshTokenService (변경 없음)
public protocol RefreshTokenServiceType {
  func refreshAccessToken(refreshToken: String) -> Single<RefreshTokenResponse>
}

public struct RefreshTokenResponse: Codable {
  public let accessToken: String
  public let refreshToken: String
}

public final class RefreshTokenService: RefreshTokenServiceType {
  private let provider: MoyaProvider<AuthAPI>

  public init(provider: MoyaProvider<AuthAPI>) {
    self.provider = provider
  }

  public func refreshAccessToken(refreshToken: String) -> Single<RefreshTokenResponse> {
    return provider.rx.request(.refreshToken(refreshToken: refreshToken))
      .asObservable()
      .flatMap { response -> Observable<RefreshTokenResponse> in
        let decoder = JSONDecoder()
        do {
          let decodedObject = try decoder.decode(RefreshTokenResponse.self, from: response.data)
          return .just(decodedObject)
        } catch {
          print("RefreshTokenService: Decoding error: \(error.localizedDescription)")
          return .error(NetworkError.decodingError(error))
        }
      }
      .asSingle()
  }
}

// MARK: - AuthInterceptor (PluginType으로 정의되었는지 확인)
public final class AuthInterceptor: PluginType {
  private let tokenStorage: TokenStorageType
  private let refreshTokenService: RefreshTokenServiceType
  private let disposeBag = DisposeBag()
  private var isTokenRefreshing = false
  private let refreshTokenSubject = PublishSubject<String>()

  public init(tokenStorage: TokenStorageType, refreshTokenService: RefreshTokenServiceType) {
    self.tokenStorage = tokenStorage
    self.refreshTokenService = refreshTokenService
  }

  // MARK: PluginType Methods
  public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var authorizedRequest = request
    if let authTarget = target as? AuthAPI, case .refreshToken = authTarget {
      return authorizedRequest
    }

    if let accessToken = tokenStorage.getAccessToken() {
      authorizedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    return authorizedRequest
  }

  // MARK: Custom 401 Handling Method
  // 이 메서드는 NetworkService에서 호출되어 401 오류 발생 시 토큰 갱신을 시도합니다.
  public func handleUnauthorizedError<T>(
    originalTarget: T // 원본 요청 타겟 (재시도용)
  ) -> Single<Moya.Response> where T: TargetType {

    if isTokenRefreshing {
      print("AuthInterceptor: Token refresh in progress, waiting for new token.")
      return refreshTokenSubject
        .take(1)
        .flatMap { _ in
          // 더미 응답을 반환하여 NetworkService가 원본 요청을 재시도하게 합니다.
          Single.just(Moya.Response(statusCode: 200, data: Data()))
        }
        .asSingle()
    }

    isTokenRefreshing = true
    print("AuthInterceptor: 401 encountered. Attempting to refresh token...")

    guard let refreshToken = tokenStorage.getRefreshToken() else {
      isTokenRefreshing = false
      print("AuthInterceptor: No refresh token available. Clearing tokens and failing.")
      tokenStorage.clearTokens()
      return Single.error(NetworkError.unauthorized)
    }

    return refreshTokenService.refreshAccessToken(refreshToken: refreshToken)
      .flatMap { [weak self] response -> Single<Moya.Response> in
        guard let self = self else { return .error(NetworkError.unknown) }
        self.tokenStorage.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
        self.isTokenRefreshing = false
        self.refreshTokenSubject.onNext(response.accessToken)
        print("AuthInterceptor: Token refresh successful.")
        // 성공적인 더미 응답으로 NetworkService가 원본 요청 재시도를 트리거하도록 합니다.
        return Single.just(Moya.Response(statusCode: 200, data: Data()))
      }
      .catch { [weak self] error in
        self?.isTokenRefreshing = false
        self?.tokenStorage.clearTokens()
        self?.refreshTokenSubject.onError(error)
        print("AuthInterceptor: Token refresh failed: \(error.localizedDescription)")
        return Single.error(NetworkError.unauthorized)
      }
  }
}
