//
//  User.swift
//  Domain
//
//  Created by dong eun shin on 7/4/25.
//

import Foundation

//public struct User: Codable, Equatable {
//  public let id: String
//  public let name: String
//  public var isNew: Bool
//
//  public init(id: String, name: String, isNew: Bool) {
//    self.id = id
//    self.name = name
//    self.isNew = isNew
//  }
//}

public enum UserStatus: Equatable {
  case needsWalkthrough  
  case loggedIn
}
