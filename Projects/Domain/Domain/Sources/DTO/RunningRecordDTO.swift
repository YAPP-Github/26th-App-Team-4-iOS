//
//  RunningRecordDTO.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import Foundation

public struct RunningRecordDTO: Codable {
    let recordId: Int
    let totalTime: Int
    let imageUrl: String
    let totalCalories: Int
    let averagePace: Int
    let totalDistance: Int
    let title: String
    let userId: Int
    let startAt: String
    let runningPoints: [RunningPoint]
    let segments: [Segment]
}

public struct RunningPoint: Codable {
    let timeStamp: String
    let recordId: Int
    let orderNo: Int
    let distance: Int
    let pointId: Int
    let pace: Int
    let lon: Double
    let totalRunningTime: Int
    let calories: Int
    let userId: Int
    let totalRunningDistance: Int
    let lat: Double
}

public struct Segment: Codable {
    let orderNo: Int
    let distanceMeter: Int
    let averagePace: Int
}
