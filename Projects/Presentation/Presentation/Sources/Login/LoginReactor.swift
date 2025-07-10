//
//  LoginReactor.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import ReactorKit
import RxSwift
import Domain
import AuthenticationServices

public final class LoginReactor: Reactor {
  public enum Action {
    case kakaoLoginTapped
    case appleLoginTapped
    case appleLoginCompleted(AppleLoginCredential)
    case appleLoginFailed(Error)
  }
  
  public enum Mutation {
    case setLoginLoading(Bool)
    case setLoginResult(Bool)
    case setSocialLoginResult(SocialLoginResult)
    case setLoginError(Error)
  }
  
  public struct State {
    var isLoading: Bool = false
    var isLoggedIn: Bool? = nil
    var socialLoginResult: SocialLoginResult? = nil
    var error: Error? = nil
  }
  
  public let initialState = State()
  private let authUseCase: AuthUseCaseType
  private let appleLoginService: AppleLoginServiceType
  
  public init(authUseCase: AuthUseCaseType, appleLoginService: AppleLoginServiceType) {
    self.authUseCase = authUseCase
    self.appleLoginService = appleLoginService
  }
  
  // MARK: - Mutate
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .kakaoLoginTapped:
      return authUseCase.kakaoLogin()
        .asObservable()
        .map { Mutation.setSocialLoginResult($0) }
        .catch { error in
          print("Kakao Login Error: \(error.localizedDescription)")
          return .just(Mutation.setLoginError(error))
        }
      
    case .appleLoginTapped:
      appleLoginService.login()
      return .empty()
      
    case .appleLoginCompleted(let credential):
      return authUseCase.appleLogin(
        identityToken: credential.identityToken,
        authCode: credential.authorizationCode,
        email: credential.email,
        fullName: credential.fullName,
        userIdentifier: credential.userIdentifier
      )
      .asObservable()
      .map { Mutation.setSocialLoginResult($0) }
      .catch { error in
        print("Apple Login Completion Error: \(error.localizedDescription)")
        return .just(Mutation.setLoginError(error))
      }
      
    case .appleLoginFailed(let error):
      print("Apple Login Failed: \(error.localizedDescription)")
      return .just(Mutation.setLoginError(error))
    }
  }
  
  // MARK: - Reduce
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.error = nil
    
    switch mutation {
    case .setLoginLoading(let isLoading):
      newState.isLoading = isLoading
    case .setLoginResult(let isSuccess):
      newState.isLoggedIn = isSuccess
    case .setSocialLoginResult(let result):
      newState.socialLoginResult = result
      newState.isLoggedIn = true 
    case .setLoginError(let error):
      newState.error = error
      newState.isLoading = false
    }
    return newState
  }
}
