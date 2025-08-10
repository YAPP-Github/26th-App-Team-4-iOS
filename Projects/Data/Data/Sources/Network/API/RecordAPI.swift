//
//  RecordAPI.swift
//  Data
//
//  Created by JDeoks on 7/31/25.
//

import Foundation
import Moya

public enum RecordAPI: BaseAPI {
  case records(page: Int, size: Int)

  public var path: String {
    switch self {
    case .records: return "/records"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .records: return .get
    }
  }
  
  public var task: Task {
    switch self {
    case let .records(page, size):
      return .requestParameters(
        parameters: ["page": page, "size": size],
        encoding: URLEncoding.default
      )
    }
  }
}
