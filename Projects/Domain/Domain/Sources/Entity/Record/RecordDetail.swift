//
//  RecordDetail.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation

/// 전체 러닝 상세 정보 엔티티
public struct RecordDetail {
  public let recordID: Int
  public let title: String
  public let userID: Int
  public let startAt: Date
  public let totalDistance: Double      // meters
  public let totalTime: TimeInterval    // seconds
  public let totalCalories: Int
  public let averagePace: TimeInterval  // seconds
  public let imageURL: URL?
  public let runningPoints: [RecordPoint]
  public let segments: [RecordSegment]

  public init(
    recordID: Int,
    title: String,
    userID: Int,
    startAt: Date,
    totalDistance: Double,
    totalTime: TimeInterval,
    totalCalories: Int,
    averagePace: TimeInterval,
    imageURL: URL?,
    runningPoints: [RecordPoint],
    segments: [RecordSegment]
  ) {
    self.recordID = recordID
    self.title = title
    self.userID = userID
    self.startAt = startAt
    self.totalDistance = totalDistance
    self.totalTime = totalTime
    self.totalCalories = totalCalories
    self.averagePace = averagePace
    self.imageURL = imageURL
    self.runningPoints = runningPoints
    self.segments = segments
  }
}
