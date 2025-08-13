//
//  RunningRecord.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation

public struct RunningRecord {
  public let recordId: Int
  public let title: String
  public let userId: Int
  public let totalTime: Double
  public let totalDistance: Double
  public let totalCalories: Int
  public let averagePace: Double
  public let startAt: Date
  public let imageUrl: String
  public let isTimeGoalAchieved: Bool
  public let isPaceGoalAchieved: Bool
  public let isDistanceGoalAchieved: Bool
  public let segments: [RunningSegment]
  public let runningPoints: [RunningPoint]
}

public struct RunningPoint {
  public let recordId: Int
  public let orderNo: Int
  public let distance: Double
  public let pace: Double
  public let totalRunningTime: Double
  public let totalRunningDistance: Double
  public let location: (lon: Double, lat: Double)
  public let timestamp: Date?
  public let calories: Double
}

public struct RunningSegment {
    public let orderNo: Int
    public let distanceMeter: Double
    public let averagePace: Double
}
