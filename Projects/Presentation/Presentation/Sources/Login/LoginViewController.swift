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
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Moya
import RxMoya
import ReactorKit
import Core

public class LoginViewController: UIViewController, View {
  public typealias Reactor = LoginReactor

  public var disposeBag = DisposeBag()

  weak var coordinator: LoginCoordinator?

  // MARK: - UI Components
  private let logoStackView = UIStackView().then { stack in
    stack.axis = .horizontal
    stack.spacing = 10.84
    stack.alignment = .center
    stack.distribution = .fill
    stack.backgroundColor = .blue
  }

  private let logoImageView = UIImageView().then { imageView in
    imageView.contentMode = .scaleAspectFit
    if let logoImage = UIImage(named: "logo", in: Bundle.module, compatibleWith: nil) {
      imageView.image = logoImage
    }
    imageView.backgroundColor = .yellow
  }

  private let logolabel = UILabel().then { label in
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
    bindViewModel()
  }

  // MARK: - Setup UI
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(loginButtonStackView)
    view.addSubview(appleIDButton)
    view.addSubview(logoStackView)
    view.addSubview(activityIndicator)
    logoStackView.addArrangedSubview(logoImageView)
    logoStackView.addArrangedSubview(logolabel)
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
    // Action
    //    kakaoLoginButton.rx.tap
    //      .map { Reactor.Action.kakaoLoginTapped }
    //      .bind(to: reactor.action)
    //      .disposed(by: disposeBag)

    //    appleLoginButton.rx.tap
    //      .map { Reactor.Action.appleLoginTapped }
    //      .bind(to: reactor.action)
    //      .disposed(by: disposeBag)

    // State
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)

    reactor.state.compactMap { $0.socialLoginResult }
      .distinctUntilChanged { $0.user.id == $1.user.id }
      .subscribe(onNext: { [weak self] result in
        print("로그인 성공! 사용자: \(result.user.nickname), 신규 여부: \(result.isNew)")
        self?.navigateToNextScreen(isNew: result.isNew)
      })
      .disposed(by: disposeBag)

    reactor.state.compactMap { $0.error }
      .subscribe(onNext: { [weak self] error in
        self?.showAlert(title: "로그인 실패", message: error.localizedDescription)
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Bind ViewModel (Login Logic)
  private func bindViewModel() {
    kakaoLoginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.handleKakaoLogin()
      })
      .disposed(by: disposeBag)

    appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
  }

  // MARK: - Kakao Login
  private func handleKakaoLogin() {
    activityIndicator.startAnimating()
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()
        if let error = error {
          print("카카오톡 로그인 에러: \(error.localizedDescription)")
          self.showAlert(title: "로그인 실패", message: "카카오톡 로그인에 실패했습니다: \(error.localizedDescription)")
        } else if let idToken = oauthToken?.idToken {
          print("카카오톡 로그인 성공: \(idToken)")
          reactor?.action.onNext(.kakaoLoginCompleted(idToken))
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()

        if let error = error {
          print("카카오 계정 로그인 에러: \(error.localizedDescription)")
          self.showAlert(title: "로그인 실패", message: "카카오 계정 로그인에 실패했습니다: \(error.localizedDescription)")
        } else if let idToken = oauthToken?.idToken {
          print("카카오 계정 로그인 성공: \(idToken)")
          reactor?.action.onNext(.kakaoLoginCompleted(idToken))
        }
      }
    }
  }

  // MARK: - Apple Login Action
  @objc private func appleLoginButtonTapped() {
    handleAppleLogin()
  }

  // MARK: - Apple Login
  private func handleAppleLogin() {
    activityIndicator.startAnimating()
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  // MARK: - Navigation
  private func navigateToNextScreen(isNew: Bool) {
    if isNew {
      coordinator?.showOnboarding()
    } else {
      // TODO: -
      coordinator?.showOnboarding()
    }
  }

  // MARK: - Helper
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - ASAuthorizationControllerDelegate (Apple Login Delegate)
extension LoginViewController: ASAuthorizationControllerDelegate {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    activityIndicator.stopAnimating()

    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let appleIDTokenData = appleIDCredential.identityToken else {
        print("Apple ID Token을 가져올 수 없습니다.")
        showAlert(title: "로그인 실패", message: "Apple ID Token을 가져올 수 없습니다.")
        return
      }

      guard let idToken = String(data: appleIDTokenData, encoding: .utf8) else {
        print("Apple ID Token 디코딩 실패")
        showAlert(title: "로그인 실패", message: "Apple ID Token 디코딩에 실패했습니다.")
        return
      }

      print("애플 로그인 성공!")
      print("ID Token: \(idToken)")

      reactor?.action.onNext(.appleLoginCompleted(idToken))

    } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
      let username = passwordCredential.user
      let password = passwordCredential.password
      print("기존 패스워드 크리덴셜 사용: \(username), \(password)")
    }
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    activityIndicator.stopAnimating()
    print("애플 로그인 에러: \(error.localizedDescription)")
    if let authorizationError = error as? ASAuthorizationError {
      if authorizationError.code == .canceled {
        print("애플 로그인 취소")
      } else {
        showAlert(title: "로그인 실패", message: "애플 로그인에 실패했습니다: \(error.localizedDescription)")
      }
    } else {
      showAlert(title: "로그인 실패", message: "애플 로그인에 실패했습니다: \(error.localizedDescription)")
    }
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    guard let window = self.view.window else {
      fatalError("Window is not available for presenting authorization controller")
    }
    return window
  }
}
