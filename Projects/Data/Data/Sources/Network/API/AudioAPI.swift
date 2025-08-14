//
//  AudioAPI.swift
//  Data
//
//  Created by dong eun shin on 8/5/25.
//

import Foundation
import Moya
import Domain

public enum AudioAPI: BaseAPI {
  case coach
  case runningInfo(paceMills: String)
  case distance(type: String)
  case paceFeedback(type: String)
  case timeFeedback(type: String)

  public var path: String {
    switch self {
    case .coach:
      return "/audios/coach"
    case .runningInfo:
      return "/audios/running-info"
    case .distance:
      return "/audios/goals/distance"
    case .paceFeedback:
      return "/audios/goals/pace"
    case .timeFeedback:
      return "/audios/goals/time"
    }
  }
  
  public var method: Moya.Method {
    return .get
  }
  
  public var task: Task {
    switch self {
    case .coach:
      return .requestPlain
    case .runningInfo(let paceMills):
      return .requestParameters(parameters: ["paceMills": paceMills], encoding: URLEncoding.default)
    case .distance(let type):
      return .requestParameters(parameters: ["type": type], encoding: URLEncoding.default)
    case .paceFeedback(let type):
      return .requestParameters(parameters: ["type": type], encoding: URLEncoding.default)
    case .timeFeedback(let type):
      return .requestParameters(parameters: ["type": type], encoding: URLEncoding.default)
    }
  }
}
