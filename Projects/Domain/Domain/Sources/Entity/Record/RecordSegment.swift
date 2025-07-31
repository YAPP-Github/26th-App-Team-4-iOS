//
//  RecordSegment.swift
//  Domain
//
//  Created by JDeoks on 7/31/25.
//

import Foundation

/// 1km 구간별 통계 엔티티
public struct RecordSegment {
  public let orderNo: Int
  public let distanceMeter: Double      // meters
  public let averagePace: TimeInterval  // seconds

  public init(
    orderNo: Int,
    distanceMeter: Double,
    averagePace: TimeInterval
  ) {
    self.orderNo = orderNo
    self.distanceMeter = distanceMeter
    self.averagePace = averagePace
  }
}
