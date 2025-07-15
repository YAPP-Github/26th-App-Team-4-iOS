//
//  SaveOnboardingUseCaseType.swift
//  Domain
//
//  Created by JDeoks on 7/13/25.
//


import RxSwift

public protocol OnboardingUseCase {
  func saveOnboarding(_ answers: [OnboardingAnswer]) -> Single<Bool>
  func savePurpose(_ purpose: String) -> Single<Bool>
}

public final class OnboardingUseCaseImpl: OnboardingUseCase {
  private let repository: OnboardingRepository

  public init(repository: OnboardingRepository) {
    self.repository = repository
  }

  public func saveOnboarding(_ answers: [OnboardingAnswer]) -> Single<Bool> {
    print("\(type(of: self)) - \(#function)")

    return repository.saveOnboarding(answers: answers)
  }

  public func savePurpose(_ purpose: String) -> RxSwift.Single<Bool> {
    return repository.savePurpose(purpose: purpose)
  }
}
