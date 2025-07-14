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
    print("\(type(of: self)) - \(#function)")

    let payload: [[String: Any]] = answers.map {
      [
        "questionType": $0.questionType,
        "answer": $0.answer
      ]
    }
    
    return provider
      .request(.saveOnboarding(answers: payload))
//      .filter(statusCodes: 200..<300)
      .map {
        print("OnboardingRepositoryImpl - saveOnboarding", $0)
        return $0
      }
      .map(APIResponse<OnboardingDTD>.self)
      .map { $0.code == "SUCCESS" }
      .asSingle()
  }
}
