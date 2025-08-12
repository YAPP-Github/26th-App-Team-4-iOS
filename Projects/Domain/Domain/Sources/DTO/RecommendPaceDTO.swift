//
//  RecommendPaceDTO.swift
//  Domain
//
//  Created by dong eun shin on 8/13/25.
//

import Foundation

public struct RecommendPaceDTO: Codable {
  public let userId: Int
  public let recommendPace: Int
}

extension RecommendPaceDTO {
  public func toDomain() -> RecommendPace {
    return RecommendPace(
      userId: userId,
      recommendPace: recommendPace
    )
  }
}
