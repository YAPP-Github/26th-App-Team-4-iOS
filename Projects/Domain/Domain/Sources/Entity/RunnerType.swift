//
//  RunnerType.swift
//  Domain
//
//  Created by JDeoks on 8/15/25.
//

public enum RunnerType: String, Decodable {
  case beginner = "BEGINNER"
  case intermediate = "INTERMEDIATE"
  case expert = "EXPERT"
   
  public var displayName: String {
    switch self {
    case .beginner:
      return "워밍업 러너"
    case .intermediate:
      return "루틴"
    case .expert:
      return "챌린저"
    }
  }
}
