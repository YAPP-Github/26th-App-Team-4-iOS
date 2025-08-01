//
//  RecordPoint.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation

/// 단일 러닝 - 단일 포인트 엔티티
public struct RecordPoint {
  public let pointID: Int
  public let userID: Int
  public let recordID: Int
  public let orderNo: Int
  public let latitude: Double
  public let longitude: Double
  public let distance: Double           // meters
  public let pace: TimeInterval         // seconds
  public let calories: Int
  public let totalRunningTime: TimeInterval // seconds
  public let totalRunningDistance: Double   // meters
  public let timestamp: Date

  public init(
    pointID: Int,
    userID: Int,
    recordID: Int,
    orderNo: Int,
    latitude: Double,
    longitude: Double,
    distance: Double,
    pace: TimeInterval,
    calories: Int,
    totalRunningTime: TimeInterval,
    totalRunningDistance: Double,
    timestamp: Date
  ) {
    self.pointID = pointID
    self.userID = userID
    self.recordID = recordID
    self.orderNo = orderNo
    self.latitude = latitude
    self.longitude = longitude
    self.distance = distance
    self.pace = pace
    self.calories = calories
    self.totalRunningTime = totalRunningTime
    self.totalRunningDistance = totalRunningDistance
    self.timestamp = timestamp
  }
}
