//
//  AppleLoginCredential.swift
//  Domain
//
//  Created by dong eun shin on 7/7/25.
//


import Foundation
import RxSwift
import AuthenticationServices

public struct AppleLoginCredential {
  public let identityToken: String
  public let authorizationCode: String?
  public let email: String?
  public let fullName: String?
  public let userIdentifier: String

  public init(identityToken: String, authorizationCode: String?, email: String?, fullName: String?, userIdentifier: String) {
    self.identityToken = identityToken
    self.authorizationCode = authorizationCode
    self.email = email
    self.fullName = fullName
    self.userIdentifier = userIdentifier
  }
}

public protocol AppleLoginServiceType: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  var rxResult: PublishSubject<AppleLoginCredential> { get }
  var rxError: PublishSubject<Error> { get }
  func login()
}
