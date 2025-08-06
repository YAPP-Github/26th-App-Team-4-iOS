//
//  RunningAPI.swift
//  Data
//
//  Created by dong eun shin on 8/1/25.
//

import UIKit
import Moya
import CoreLocation

public enum RunningAPI: BaseAPI {
  case startRun(lat: Double, lon: Double, timeStamp: String)
  case completeRun(recordId: String, data: RunningCompletionRequestDTO)
  case uploadImage(recordId: String, image: UIImage)

  public var path: String {
    switch self {
    case .startRun:
      return "/running"
    case .completeRun(let recordId, _):
      return "/running/\(recordId)"
    case .uploadImage(let recordId, _):
      return "/running/\(recordId)/images"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .startRun: return .post
    case .completeRun: return .post
    case .uploadImage: return .post
    }
  }

  public var task: Task {
    switch self {
    case let .startRun(lat, lon, timeStamp):
      return .requestParameters(
        parameters: [
          "timeStamp":timeStamp,
          "lon": lon,
          "lat": lat
        ],
        encoding: JSONEncoding.default
      )

    case let .completeRun(_, data):
      return .requestJSONEncodable(data)

    case .uploadImage(_, image: let image):
      return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
    }
  }
}



public struct RunningStartResponseDTO: Codable {
  let recordId: Int
}

public struct RunningPointRequestDTO: Codable {
  let timeStamp: String
  let totalRunningTimeMills: Int64
  let lon: Double
  let lat: Double
}

public struct RunningCompletionRequestDTO: Codable {
  let runningPoints: [RunningPointRequestDTO]
  let totalTime: Int64
  let totalCalories: Int
  let averagePace: Int64
  let totalDistance: Double
  let startAt: String
}
