//
//  LoginViewController.swift
//  Presentation
//
//  Created by dong eun shin on 6/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices
import ReactorKit
import Core

public class LoginViewController: BaseViewController, View {
  public typealias Reactor = LoginReactor

  weak var coordinator: LoginCoordinator?

  // MARK: - UI Components
  private let logoStackView = UIStackView().then { stack in
    stack.axis = .horizontal
    stack.spacing = 10.84
    stack.alignment = .center
    stack.distribution = .fill
  }

  private let logoImageView = UIImageView().then { imageView in
    imageView.contentMode = .scaleAspectFit
    if let logoImage = UIImage(named: "logo", in: Bundle.module, compatibleWith: nil) {
      imageView.image = logoImage
    }
    imageView.backgroundColor = .yellow
  }

  private let logoLabel = UILabel().then { label in
    label.text = "fitrun"
    label.textColor = .orange
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }

  private let loginButtonStackView = UIStackView().then { stack in
    stack.axis = .vertical
    stack.spacing = 12
    stack.alignment = .fill
    stack.distribution = .fill
  }

  private let kakaoLoginButton: UIButton = {
    var config = UIButton.Configuration.filled()

    if let originalImage = UIImage(named: "kakao_icon", in: Bundle.module, compatibleWith: nil) {
      let resizedImage = originalImage.resized(to: CGSize(width: 26, height: 26))
      config.image = resizedImage
    }

    config.title = "카카오로 시작하기"
    config.imagePlacement = .leading
    config.imagePadding = 6
    config.baseForegroundColor = .black
    config.baseBackgroundColor = .yellow

    let button = UIButton(configuration: config, primaryAction: nil)
    button.layer.cornerRadius = 10
    button.clipsToBounds = true

    return button
  }()

  private let appleLoginButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.title = "애플로 시작하기"
    config.image = UIImage(systemName: "applelogo")
    config.imagePlacement = .leading
    config.imagePadding = 8.5
    config.baseBackgroundColor = .black

    let button = UIButton(configuration: config, primaryAction: nil)
    button.layer.cornerRadius = 10
    button.clipsToBounds = true
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.white.cgColor

    return button
  }()

  private let appleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black).then {
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.alpha = 0.0
    $0.backgroundColor = .clear
  }

  private let activityIndicator = UIActivityIndicatorView().then { indicator in
    indicator.hidesWhenStopped = true
  }

  // MARK: - Life Cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  // MARK: - Setup UI
  private func setupUI() {
    view.addSubview(logoStackView)
    view.addSubview(loginButtonStackView)
    view.addSubview(appleIDButton)
    view.addSubview(activityIndicator)
    logoStackView.addArrangedSubview(logoImageView)
    logoStackView.addArrangedSubview(logoLabel)
    loginButtonStackView.addArrangedSubview(kakaoLoginButton)
    loginButtonStackView.addArrangedSubview(appleLoginButton)

    logoImageView.snp.makeConstraints { make in
      make.height.equalTo(54.74)
      make.width.equalTo(41.19)
    }

    logoStackView.snp.makeConstraints { make in
      make.height.equalTo(77)
      make.center.equalToSuperview()
    }

    loginButtonStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(40)
      make.bottom.equalToSuperview().inset(78)
    }

    kakaoLoginButton.snp.makeConstraints { make in
      make.height.equalTo(50)
    }

    appleLoginButton.snp.makeConstraints { make in
      make.height.equalTo(50)
    }

    appleIDButton.snp.makeConstraints { make in
      make.edges.equalTo(appleLoginButton)
    }

    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  public func bind(reactor: LoginReactor) {
    kakaoLoginButton.rx.tap
      .map { Reactor.Action.kakaoLoginTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    appleLoginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.appleLoginButtonTapped()
      })
      .disposed(by: disposeBag)

    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)

    reactor.state.compactMap { $0.socialLoginResult }
      .distinctUntilChanged { $0.user.userId == $1.user.userId }
      .subscribe(onNext: { [weak self] result in
        print("로그인 성공! 사용자: \(result.user.nickname), 신규 여부: \(result.isNew)")
        self?.navigateToNextScreen()
      })
      .disposed(by: disposeBag)

    reactor.state.compactMap { $0.error }
      .subscribe(onNext: { [weak self] error in
        self?.showAlert(title: "로그인 실패", message: error)
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Apple Login Action
  @objc private func appleLoginButtonTapped() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()

    activityIndicator.startAnimating()
  }

  // MARK: - Navigation
  private func navigateToNextScreen() {
    coordinator?.showOnboarding()
  }

  // MARK: - Helper
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

// MARK: - ASAuthorizationControllerDelegate (Apple Login Delegate)
extension LoginViewController: ASAuthorizationControllerDelegate {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    activityIndicator.stopAnimating()

    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
       let tokenData = credential.identityToken,
       let idToken = String(data: tokenData, encoding: .utf8) {
      print("애플 로그인 성공! >> ID Token: \(idToken)")
      reactor?.action.onNext(.appleLoginCompleted(idToken))
    } else {
      showAlert(title: "로그인 실패", message: "애플 로그인 토큰을 가져올 수 없습니다.")
    }
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    activityIndicator.stopAnimating()
    showAlert(title: "로그인 실패", message: error.localizedDescription)
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window ?? UIWindow()
  }
}
