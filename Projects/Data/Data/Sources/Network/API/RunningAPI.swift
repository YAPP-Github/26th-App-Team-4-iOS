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
  case saveRunningRecord(recordId: String, metadata: Data, image: UIImage)

  public var path: String {
    switch self {
    case .saveRunningRecord(let recordId, _, _): return "/running/\(recordId)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .saveRunningRecord: return .post
    }
  }

  public var headers: [String: String]? {
    return CommonNetworkHeaders.runningAPI
  }

//  public var task: Task {
//    switch self {
//    case .saveRunningRecord:
//      return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
//    }
//  }
  public var task: Task {
    switch self {
    case let .saveRunningRecord(_, metadata, image):
      guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        return .uploadMultipart([])
      }

      // image 파트
      let imageDataPart = MultipartFormData(provider: .data(imageData), name: "image", fileName: "running_map.jpg", mimeType: "image/jpeg")

      // metadata 파트 (JSON 데이터)
      let metadataPart = MultipartFormData(provider: .data(metadata), name: "metadata", fileName: "metadata.json", mimeType: "application/json")

      return .uploadMultipart([imageDataPart, metadataPart])
    }
  }
}
