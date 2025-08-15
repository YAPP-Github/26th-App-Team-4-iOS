//
//  MyProfileReactor.swift
//  Presentation
//
//  Created by JDeoks on 8/15/25.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public final class MyProfileReactor: Reactor {
  
  public enum Action {
    case initialize
  }
  
  public enum Mutation {
    case setprofileInfo(ProfileInfo)
  }
  
  public struct State {
    fileprivate(set) var profileInfo: ProfileInfo? = nil
  }
  
  public var initialState: State = State()
  
  private let userUseCase: UserUseCase
  private let onboardngUseCase: OnboardingUseCase
  
  init(userUseCase: UserUseCase, onboardngUseCase: OnboardingUseCase) {
    self.userUseCase = userUseCase
    self.onboardngUseCase = onboardngUseCase
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    print("\(type(of: self)) - \(#function)")

    switch action {
    case .initialize:
      return fetchUserInfo()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    print(self, #function, state, mutation)
    var newState = state
    switch mutation {
    case let .setprofileInfo(profileInfo):
      newState.profileInfo = profileInfo
    }
    return newState
  }
  
  private func fetchUserInfo() -> Observable<Mutation> {
    return userUseCase
      .fetchMyUserInfo()
      .map { Mutation.setprofileInfo($0) }
      .asObservable()
  }
}
