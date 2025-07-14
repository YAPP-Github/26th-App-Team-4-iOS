//
//  OnboardingRepository.swift
//  Domain
//
//  Created by JDeoks on 7/13/25.
//


import RxSwift

public protocol OnboardingRepository {
  /// 온보딩 답변 저장을 서버에 요청하고, 그 결과(OnboardingResult)를 반환
  func saveOnboarding(answers: [OnboardingAnswer]) -> Single<Bool>
}
