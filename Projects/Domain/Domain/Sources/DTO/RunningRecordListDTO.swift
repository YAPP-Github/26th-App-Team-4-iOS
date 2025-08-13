//
//  RunningRecordListDTO.swift
//  Domain
//
//  Created by dong eun shin on 8/13/25.
//

import Foundation

public struct RunningRecordListDTO: Codable {
    public let records: [RecordDTO]
    public let totalTime: Double
    public let recordCount: Int
    public let totalCalories: Double
    public let averagePace: Double
    public let totalDistance: Double
    public let userId: Int
    public let timeGoalAchievedCount: Int
    public let distanceGoalAchievedCount: Int

    public func toEntity() -> RecordList {
        let recordEntities = records.map { $0.toEntity() }
        return RecordList(
            records: recordEntities,
            totalTime: self.totalTime,
            recordCount: self.recordCount,
            totalCalories: self.totalCalories,
            averagePace: self.averagePace,
            totalDistance: self.totalDistance,
            userId: self.userId,
            timeGoalAchievedCount: self.timeGoalAchievedCount,
            distanceGoalAchievedCount: self.distanceGoalAchievedCount
        )
    }
}

// MARK: - RecordDTO
public struct RecordDTO: Codable {
    public let recordId: Int
    public let totalTime: Double
    public let imageUrl: String
    public let averagePace: Double
    public let totalDistance: Double
    public let title: String
    public let userId: Int
    public let startAt: String

    public func toEntity() -> RecordEntity {
        return RecordEntity(
            recordId: self.recordId,
            totalTime: self.totalTime,
            imageUrl: self.imageUrl,
            averagePace: self.averagePace,
            totalDistance: self.totalDistance,
            title: self.title,
            userId: self.userId,
            startAt: self.startAt
        )
    }
}

// MARK: - RecordListEntity
public struct RecordList: Equatable {
    public let records: [RecordEntity]
    public let totalTime: Double
    public let recordCount: Int
    public let totalCalories: Double
    public let averagePace: Double
    public let totalDistance: Double
    public let userId: Int
    public let timeGoalAchievedCount: Int
    public let distanceGoalAchievedCount: Int
}

// MARK: - RecordEntity
public struct RecordEntity: Equatable {
    public let recordId: Int
    public let totalTime: Double
    public let imageUrl: String
    public let averagePace: Double
    public let totalDistance: Double
    public let title: String
    public let userId: Int
    public let startAt: String
}
