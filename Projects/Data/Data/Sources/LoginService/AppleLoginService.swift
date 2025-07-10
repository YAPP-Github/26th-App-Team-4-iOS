//
//  AppleLoginService.swift
//  Data
//
//  Created by dong eun shin on 7/7/25.
//

import Foundation
import RxSwift
import AuthenticationServices
import Domain

public final class AppleLoginService: NSObject, AppleLoginServiceType {
  public let rxResult = PublishSubject<AppleLoginCredential>()
  public let rxError = PublishSubject<Error>()

  public override init() {
    super.init()
  }

  public func login() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let identityTokenData = appleIDCredential.identityToken,
            let identityTokenString = String(data: identityTokenData, encoding: .utf8) else {
        rxError.onNext(NSError(domain: "AppleLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID Token이 없습니다."]))
        return
      }

      let authorizationCodeData = appleIDCredential.authorizationCode
      let authorizationCodeString = authorizationCodeData.map { String(data: $0, encoding: .utf8) }

      let appleLoginCredential = AppleLoginCredential(
        identityToken: identityTokenString,
        authorizationCode: authorizationCodeString as! String, // TODO: -
        email: appleIDCredential.email,
        fullName: appleIDCredential.fullName.map { "\($0.givenName ?? "") \($0.familyName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines) },
        userIdentifier: appleIDCredential.user
      )
      rxResult.onNext(appleLoginCredential)

    } else {
      rxError.onNext(NSError(domain: "AppleLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Apple ID Credential을 가져오는 데 실패했습니다."]))
    }
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    rxError.onNext(error)
  }

  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.shared.windows.first!
  }
}
