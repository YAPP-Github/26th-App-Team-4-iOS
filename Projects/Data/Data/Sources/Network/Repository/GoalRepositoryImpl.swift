//
//  GoalRepositoryImpl.swift
//  Data
//
//  Created by JDeoks on 7/19/25.
//

import Foundation
import Moya
import RxSwift
import Domain

public final class GoalRepositoryImpl: GoalRepository {

  private let provider: NetworkProvider<GoalAPI>
  
  public init(provider: NetworkProvider<GoalAPI> = .init()) {
    self.provider = provider
  }
    
  public func fetchPaceRunningCount() -> Single<PaceRunningCount> {
    return provider.request(.goal)
      .filter(statusCodes: 200..<300)
      .map(APIResponse<GoalDTO>.self)
      .map { response in
        guard let dto = response.result else {
          throw NSError(domain: "GoalRepositoryImpl", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result found"])
        }
        return dto.toPaceRunningCount()
      }
      .asSingle()
  }
  
  public func savePaceGoal(paceGoalMS: Int) -> Single<Bool> {
    return provider.request(.savePace(paceGoalMs: paceGoalMS))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<GoalDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
  
  public func saveRunningCount(count: Int) -> Single<Bool> {
    return provider.request(.saveRunningCount(weeklyRunningCount: count))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<GoalDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }

  public func saveGoalTime(time: Int) -> Single<Bool> {
    return provider.request(.saveGoalTime(time: time))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<GoalDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }

  public func saveGoalDistance(distance: Int) -> Single<Bool> {
    return provider.request(.saveGoalDistance(distance: distance))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<GoalDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
}
