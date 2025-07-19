//
//  HomeAPI.swift
//  Data
//
//  Created by JDeoks on 7/19/25.
//

import Foundation
import Moya

public enum HomeAPI: BaseAPI {
  case home

  public var path: String {
    switch self {
    case .home: return "/home"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .home: return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .home:
      return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }
  }
}
