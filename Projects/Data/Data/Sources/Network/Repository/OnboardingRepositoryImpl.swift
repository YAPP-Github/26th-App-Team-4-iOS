//
//  OnboardingRepositoryImpl.swift
//  Data
//
//  Created by JDeoks on 7/14/25.
//

import Foundation
import Moya
import RxSwift

import Domain

public final class OnboardingRepositoryImpl: OnboardingRepository {

  private let userProvider: NetworkProvider<UserAPI>
  private let goalProvider: NetworkProvider<GoalAPI>
  
  /// 기본적으로 UserAPI 를 사용합니다.
  public init(
    userProvider: NetworkProvider<UserAPI> = .init(),
    goalProvider: NetworkProvider<GoalAPI> = .init()
  ) {
    self.userProvider = userProvider
    self.goalProvider = goalProvider
  }

  public func saveOnboarding(answers: [OnboardingAnswer]) -> Single<Bool> {
    let payload: [[String: Any]] = answers.compactMap { ans in
      return [
        "questionType": ans.questionType,
        "answer": ans.answer
      ]
    }
    return userProvider
      .request(.saveOnboarding(answers: payload))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<OnboardingDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
  
  public func savePurpose(purpose: String) -> RxSwift.Single<Bool> {
    return goalProvider
      .request(.savePurpose(runningPurpose: purpose))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<OnboardingDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
  
  public func getRuunerType() -> RxSwift.Single<String?> {
    return userProvider
      .request(.type)
      .filter(statusCodes: 200..<300)
      .map(APIResponse<RunnerTypeDTO>.self)
      .map { $0.result?.runnerType }
      .asSingle()
  }
}
