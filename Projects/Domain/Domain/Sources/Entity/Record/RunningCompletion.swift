//
//  RunningCompletion.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import Foundation
import CoreLocation

public struct Point {
  public let coordinate: CLLocationCoordinate2D
  public let timestamp: Date

  public init(coordinate: CLLocationCoordinate2D, timestamp: Date) {
    self.coordinate = coordinate
    self.timestamp = timestamp
  }
}

public  struct RunningCompletion {
  public let runningPoints: [Point]
  public let totalTime: TimeInterval
  public let totalCalories: Int
  public let averagePace: TimeInterval
  public let totalDistance: Double
  public let startAt: Date
}
