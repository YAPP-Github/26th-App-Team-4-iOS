//
//  RunningRecordDTO.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import Foundation

public struct RunningRecordDTO: Codable {
  public let runningPoints: [RunningPointDTO]
  /// 총 러닝 시간 밀리초 단위
  public let totalTime: Double
  public let totalCalories: Double
  public let averagePace: Double
  public let title: String
  public let userId: Int
  /// 구간 기록 리스트(1km 구간별 정보)
  public let segments: [RunningSegmentDTO]
  public let recordId: Int
  /// 러닝 경로 이미지 URL
  public let imageUrl: String?
  /// 시간 목표 달성 여부, 목표가 설정되어 있지 않으면 false 입니다.
  public let isTimeGoalAchieved: Bool
  /// 페이스 목표 달성 여부, 목표가 설정되어 있지 않으면 false 입니다.
  public let isPaceGoalAchieved: Bool
  /// 거리 목표 달성 여부, 목표가 설정되어 있지 않으면 false 입니다.
  public let isDistanceGoalAchieved: Bool
  /// 총 이동 거리(m)
  public let totalDistance: Double
  public let startAt: String
}

public struct RunningPointDTO: Codable {
  /// 러닝 포인트 기록 시간
  public let timestamp: String?
  public let recordId: Int
  /// 러닝 포인트 순서
  public let orderNo: Int
  /// 거리(m)/
  public let distance: Double
  public let pointId: Int
  /// 페이스 밀리초 단위
  public let pace: Double
  public let lon: Double
  /// 러닝 포인트 기록 당시 총 러닝 시간 밀리초 단위
  public let totalRunningTime: Double
  public let calories: Double
  public let userId: Int
  /// 러닝 포인트 기록 당시 총 러닝 거리/
  public let totalRunningDistance: Double
  public let lat: Double
}

public struct RunningSegmentDTO: Codable {
  public let orderNo: Int
  public let distanceMeter: Double
  public let averagePace: Double
}

extension RunningRecordDTO {
  public func toDomain() -> RunningRecord? {

    let dateFormatter = ISO8601DateFormatter()

    guard let startAtDate = dateFormatter.date(from: self.startAt) else {
      return nil
    }

    let runningPointEntities = self.runningPoints.compactMap { $0.toDomain() }
    let segmentsEntities = self.segments.compactMap { $0.toDomain() }
    print("segments>>>", self.segments)

    return RunningRecord(
      recordId: self.recordId,
      title: self.title,
      userId: self.userId,
      totalTime: self.totalTime,
      totalDistance: self.totalDistance,
      totalCalories: Int(self.totalCalories),
      averagePace: self.averagePace,
      startAt: startAtDate,
      imageUrl: self.imageUrl,
      isTimeGoalAchieved: self.isTimeGoalAchieved,
      isPaceGoalAchieved: self.isPaceGoalAchieved,
      isDistanceGoalAchieved: self.isDistanceGoalAchieved,
      segments: segmentsEntities,
      runningPoints: runningPointEntities
    )
  }
}

extension RunningPointDTO {
  public func toDomain() -> RunningPoint? {

    let dateFormatter = ISO8601DateFormatter()

    return RunningPoint(
      recordId: self.recordId,
      orderNo: self.orderNo,
      distance: self.distance,
      pace: self.pace,
      totalRunningTime: self.totalRunningTime,
      totalRunningDistance: self.totalRunningDistance,
      location: (lon: self.lon, lat: self.lat),
      timestamp: dateFormatter.date(from: self.timestamp ?? ""),
      calories: self.calories
    )
  }
}

extension RunningSegmentDTO {
  public func toDomain() -> RunningSegment? {
    return RunningSegment(
      orderNo: orderNo,
      distanceMeter: distanceMeter,
      averagePace: averagePace
    )
  }
}
