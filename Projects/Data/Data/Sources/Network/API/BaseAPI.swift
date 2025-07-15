//
//  BaseAPI.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import Moya

public protocol BaseAPI: TargetType {
  var baseURL: URL { get }
  var headers: [String: String]? { get }
}

extension BaseAPI {
  public var baseURL: URL {
    return URL(string: "http://fitrun.p-e.kr/api/v1")!
    // TODO: - config파일에 BASE_API_URL 추가
    guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_API_URL") as? String,
          let url = URL(string: urlString) else {
      fatalError("BASE_API_URL not set in Info.plist or invalid format.")
    }
    return url
  }
  
  public var headers: [String: String]? {
    return CommonNetworkHeaders.default
  }
  
  public var task: Task {
    return .requestPlain
  }
  
  public var validationHeader: Bool { return false }
}
