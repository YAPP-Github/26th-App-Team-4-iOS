//
//  LoginUseCase.swift
//  Domain
//
//  Created by dong eun shin on 6/27/25.
//

public protocol LoginUseCase {
}

public final class LoginUseCaseImpl: LoginUseCase {
  let repository: LoginRepository

  init(repository: LoginRepository) {
      self.repository = repository
  }
  
}
