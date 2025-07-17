//
//  CommonNetworkHeaders.swift
//  Data
//
//  Created by dong eun shin on 7/8/25.
//


import Foundation

public struct CommonNetworkHeaders {
  /// 기본 헤더 + 동적으로 저장된 Access Token 을 붙입니다.
  public static var `default`: [String: String] {
    var headers: [String: String] = [
      "Content-Type": "application/json"
    ]

    // AuthTokenStorageType 을 구현한 싱글톤 또는 DI 컨테이너에서 가져오세요.
    if let token = AuthTokenStorageImpl().getAccessToken() {
      headers["Authorization"] = "Bearer \(token)"
    }

    return headers
  }
}
