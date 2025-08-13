//
//  RunningRepositoryImpl.swift
//  Data
//
//  Created by dong eun shin on on 8/2/25.
//

import UIKit
import Moya
import RxSwift
import CoreLocation
import Domain

public final class RunningRepositoryImpl: RunningRepository {
  private let provider = MoyaProvider<RunningAPI>()

  private let iso8601Formatter = ISO8601DateFormatter()

  public func startRun(startLocation: CLLocation, timeStamp: Date) -> Single<Int?> { // public으로 변경
    let lat = startLocation.coordinate.latitude
    let lon = startLocation.coordinate.longitude
    let timeStampString = iso8601Formatter.string(from: timeStamp)

    return provider.rx.request(.startRun(lat: lat, lon: lon, timeStamp: timeStampString))
      .map(APIResponse<RunningStartResponseDTO>.self)
      .map { $0.result?.recordId }
      .catch { error in
        print("Error starting run: \(error.localizedDescription)")
        return .error(error)
      }
  }

  public func completeRun(recordId: Int, completionData: RunningCompletionData) -> Single<Bool> {
    let pointsDTO: [RunningPointRequestDTO] = completionData.runningPoints.map { point in
      let totalRunningTimeMills = Int64(point.timestamp.timeIntervalSince(completionData.startAt) * 1000)
      return RunningPointRequestDTO(
        timeStamp: ISO8601DateFormatter().string(from: point.timestamp),
        totalRunningTimeMills: totalRunningTimeMills,
        lon: point.coordinate.longitude,
        lat: point.coordinate.latitude
      )
    }

    let metadata = RunningCompletionRequestDTO(
      runningPoints: pointsDTO,
      totalTime: Int64(completionData.totalTime * 1000),
      totalCalories: completionData.totalCalories,
      averagePace: Int64(completionData.averagePace * 1000),
      totalDistance: completionData.totalDistance,
      startAt: ISO8601DateFormatter().string(from: completionData.startAt)
    )

    return provider.rx.request(.completeRun(recordId: recordId, data: metadata))
      .map { response in
        return (200...299).contains(response.statusCode)
      }
      .catch { error -> Single<Bool> in
        print("Error completing run: \(error.localizedDescription)")
        return .just(false)
      }
  }
}
