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
  public let totalDistance: Double      // 미터
  public let totalTime: TimeInterval    // 밀리초
  public let totalCalories: Int
  public let averagePace: TimeInterval  // 밀리초
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
  
  public static let dummy = RecordDetail(
    recordID: 1,
    title: "7월 20일 점심 러닝",
    userID: 123,
    startAt: Date(),
    totalDistance: 5000,
    totalTime: 1800,
    totalCalories: 300,
    averagePace: 360, // 6 minutes per km
    imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/maumnote-dev.firebasestorage.app/o/adfhdgsg.png?alt=media&token=8b2f3a4b-1c2a-4658-acc8-1af8cd070800"),
    runningPoints: (0..<10).map { _ in RecordDetail.randomRecordPoint() },
    segments: [RecordDetail.randomRecordSegment(), RecordDetail.randomRecordSegment(), RecordDetail.randomRecordSegment(), RecordDetail.randomRecordSegment(), RecordDetail.randomRecordSegment()]
  )
  
  static func randomRecordPoint() -> RecordPoint {
    let randomID = Int.random(in: 1...1000)
    return RecordPoint(
      pointID: randomID,
      userID: randomID,
      recordID: randomID,
      orderNo: randomID,
      latitude: Double.random(in: -90...90),
      longitude: Double.random(in: -180...180),
      distance: Double.random(in: 0...10000),
      pace: Double.random(in: 240...600), // pace in seconds
      calories: Int.random(in: 50...500),
      totalRunningTime: Double.random(in: 3600...7200), // total running time in seconds
      totalRunningDistance: Double.random(in: 2000...10000), // total distance in meters
      timestamp: Date()
    )
  }
  
  static func randomRecordSegment() -> RecordSegment {
    return RecordSegment(
      orderNo: Int.random(in: 50...500),
      distanceMeter: Double.random(in: 2000...10000),
      averagePace: TimeInterval.random(in: 240...600)
    )
  }
}
