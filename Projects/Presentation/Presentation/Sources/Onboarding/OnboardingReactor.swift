//
//  OnboardingReactor.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import ReactorKit
import RxSwift
import Domain

public final class OnboardingReactor: Reactor {
  public enum Action {
    case completeOnboardingTapped
  }
  
  public enum Mutation {
    case setCompleted(Bool)
    case setErrorMessage(String?)
  }
  
  public struct State {
    var isCompleted: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
  }
  
  public var initialState: State = State()
  
  public init() {
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .completeOnboardingTapped:
      return Observable.concat([
        .just(Mutation.setErrorMessage(nil)),
        .just(Mutation.setCompleted(true)) // 실제로는 UseCase 호출하여 서버에 온보딩 완료 알림
        // 예시:
        // self.updateUserProfileUseCase.execute(user: updatedUser) // User 객체에 isOnboardingCompleted = true 설정
        //   .map { _ in Mutation.setCompleted(true) }
        //   .asObservable()
        //   .catch { .just(Mutation.setErrorMessage($0.localizedDescription)) }
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setCompleted(let completed):
      newState.isCompleted = completed
      if completed { newState.errorMessage = nil }
    case .setErrorMessage(let message):
      newState.errorMessage = message
      newState.isCompleted = false
    }
    return newState
  }
}
