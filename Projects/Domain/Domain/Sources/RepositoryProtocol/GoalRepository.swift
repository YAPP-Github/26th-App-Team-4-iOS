//
//  GoalRepository.swift
//  Domain
//
//  Created by JDeoks on 7/19/25.
//

import RxSwift


public protocol GoalRepository {
  /// 서버에서 GoalDTO를 받아 PaceRunningCount 도메인 모델로 매핑하여 반환합니다.
  func fetchPaceRunningCount() -> Single<PaceRunningCount>

  func savePaceGoal(paceGoalMS: Int) -> Single<Bool>
  
  func saveRunningCount(count: Int) -> Single<Bool>

  func saveGoalTime(time: Int) -> Single<Bool>

  func saveGoalDistance(distance: Int) -> Single<Bool>
}

