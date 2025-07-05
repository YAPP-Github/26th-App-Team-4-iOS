//
//  LoginReactor.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import ReactorKit

public final class LoginReactor: Reactor {
  public enum Action {
    case postUser
  }

  public enum Mutation {
    case showWalkThrough
  }

  public struct State {
    var user: User?
  }

  public let initialState = State()
}
