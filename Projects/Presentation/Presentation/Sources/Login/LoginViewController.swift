//
//  LoginViewController.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import ReactorKit

public final class LoginViewController: UIViewController, View {
  public var disposeBag = DisposeBag()

  weak var coordinator: LoginCoordinator?

  private let appleLoginButton = UIButton().then {
    $0.setTitle("애플로 시작하기", for: .normal)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 8
  }

  private let kakaoLoginButton = UIButton().then {
    $0.setTitle("카카오로 시작하기", for: .normal)
    $0.backgroundColor = .yellow
    $0.layer.cornerRadius = 8
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    layout()
    bindUI()
  }

  private func layout() {
    view.addSubview(appleLoginButton)
    view.addSubview(kakaoLoginButton)

    appleLoginButton.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.left.right.equalToSuperview().inset(40)
      $0.height.equalTo(56)
    }

    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(appleLoginButton.snp.bottom).offset(12)
      $0.left.right.height.equalTo(appleLoginButton)
    }
  }

  private func bindUI() {
    appleLoginButton.rx.tap
      .bind { [weak self] in self?.startAppleLogin() }
      .disposed(by: disposeBag)

    kakaoLoginButton.rx.tap
      .bind { [weak self] in self?.startKakaoLogin() }
      .disposed(by: disposeBag)
  }

  public func bind(reactor: LoginReactor) {
    // 로그인 성공
    reactor.state.map(\.user)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] user in
        self?.showAlert(title: "로그인 성공", message: "\(user.name)님 환영합니다!")
      }
      .disposed(by: disposeBag)

    // 로그인 실패
    reactor.state.map(\.loginError)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] error in
        self?.showAlert(title: "로그인 실패", message: error.localizedDescription)
      }
      .disposed(by: disposeBag)
  }

  private func startAppleLogin() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }

  private func startKakaoLogin() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { [weak self] token, error in
        self?.handleKakao(token: token?.accessToken, error: error)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { [weak self] token, error in
        self?.handleKakao(token: token?.accessToken, error: error)
      }
    }
  }

  private func handleKakao(token: String?, error: Error?) {
    guard
      let token,
      error == nil
    else {
      showAlert(title: "카카오 로그인 실패", message: error?.localizedDescription ?? "알 수 없는 오류")
      return
    }
    print("> 카카오 로그임 로그인 성공")
    reactor?.action.onNext(.loginWithKakao(token: token))
  }

  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let tokenData = credential.identityToken,
          let token = String(data: tokenData, encoding: .utf8) else {
      showAlert(title: "애플 로그인 실패", message: "토큰이 유효하지 않습니다.")
      return
    }
    print("> 카카오 로그임 로그인 성공")
    reactor?.action.onNext(.loginWithApple(token: token))
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    showAlert(title: "애플 로그인 실패", message: error.localizedDescription)
  }

  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return view.window!
  }
}
