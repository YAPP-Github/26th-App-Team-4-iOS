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
  case record(recordId: Int)
  case deleteRecord(recordId: Int)

  public var path: String {
    switch self {
    case .records: return "/records"
    case .record(let recordId): return "/records/\(recordId)"
    case .deleteRecord(recordId: let recordId): return "/records/\(recordId)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .records : return .get
    case .record : return .get
    case .deleteRecord : return .delete
    }
  }
  
  public var task: Task {
    switch self {
    case let .records(page, size):
      return .requestParameters(
        parameters: ["page": page, "size": size],
        encoding: URLEncoding.default
      )

    case .record:
      return .requestPlain

    case .deleteRecord:
      return .requestPlain
    }
  }
}
