//
//  SaveOnboardingUseCaseType.swift
//  Domain
//
//  Created by JDeoks on 7/13/25.
//


import RxSwift

public protocol SaveOnboardingUseCase {
  func execute(_ answers: [OnboardingAnswer]) -> Single<Bool>
}

public final class SaveOnboardingUseCaseImpl: SaveOnboardingUseCase {
  private let repository: OnboardingRepository

  public init(repository: OnboardingRepository) {
    self.repository = repository
  }

  public func execute(_ answers: [OnboardingAnswer]) -> Single<Bool> {
    print("\(type(of: self)) - \(#function)")

    return repository.saveOnboarding(answers: answers)
  }
}
