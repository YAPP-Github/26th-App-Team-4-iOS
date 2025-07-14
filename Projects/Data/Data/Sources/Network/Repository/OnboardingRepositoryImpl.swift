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

  private let provider: NetworkProvider<UserAPI>
  
  /// 기본적으로 UserAPI 를 사용합니다.
  public init(
    provider: NetworkProvider<UserAPI> = .init()
  ) {
    self.provider = provider
  }

  public func saveOnboarding(answers: [OnboardingAnswer]) -> Single<Bool> {
    let payload: [[String: Any]] = answers.compactMap { ans in
      guard ans.questionType != "GOAL_SELECTION" else { return nil }
      return [
        "questionType": ans.questionType,
        "answer": ans.answer
      ]
    }
    let request = UserAPI.saveOnboarding(answers: payload)
    return provider
      .request(.saveOnboarding(answers: payload))
      .filter(statusCodes: 200..<300)
      .map(APIResponse<OnboardingDTO>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
}
