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

public class LoginViewController: UIViewController {

  private let disposeBag = DisposeBag()

  weak var coordinator: LoginCoordinator?

  // MARK: - UI Components
  private let logoStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 10.84
    stack.alignment = .center
    stack.distribution = .fillEqually
    stack.backgroundColor = .blue
    return stack
  }()

  private let logoImageView = UIImageView().then { imageView in
    imageView.contentMode = .scaleAspectFit
    if let logoImage = UIImage(named: "logo") {
      imageView.image = logoImage
    }
    imageView.backgroundColor = .blue
  }

  private let logolabel = UILabel().then { label in
    label.text = "fitrun"
    label.textColor = .orange
  }

  private let loginButtonStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 12
    stack.alignment = .fill
    stack.distribution = .fillEqually
    return stack
  }()

  private let kakaoLoginButton = UIButton().then {
    $0.setTitle("카카오로 시작하기", for: .normal)
    $0.setImage(UIImage(systemName: "kakao_icon"), for: .normal)
    $0.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1.0)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
  }

  private let appleLoginButton = UIButton().then {
    $0.setTitle("애플로 시작하기", for: .normal)
    $0.setImage(UIImage(systemName: "applelogo"), for: .normal)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    // Add a border as seen in the screenshot
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
  }

  private let appleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black).then {
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.alpha = 0.0
    $0.backgroundColor = .clear
  }

  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.hidesWhenStopped = true
    return indicator
  }()

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
    //    view.addSubview(logoStackView)
    view.addSubview(activityIndicator)
    //
    //    logoStackView.addArrangedSubview(logoImageView)
    //    logoStackView.addArrangedSubview(logolabel)
    //    logoStackView.snp.makeConstraints { make in
    //      make.leading.trailing.equalToSuperview().inset(40)
    //      make.height.equalTo(77)
    //      make.center.equalToSuperview()
    //    }
    //
    //    logoImageView.snp.makeConstraints { make in
    //      make.width.equalTo(41.19)
    //      make.height.equalTo(54.74)
    //    }

    loginButtonStackView.addArrangedSubview(kakaoLoginButton)
    loginButtonStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(40)
      make.height.equalTo(120)
      make.bottom.equalToSuperview().inset(78)
    }

    kakaoLoginButton.snp.makeConstraints { make in
      make.height.equalTo(50)
    }

    loginButtonStackView.addArrangedSubview(appleLoginButton)
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

  // MARK: - Bind ViewModel (Login Logic)
  private func bindViewModel() {
    kakaoLoginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.handleKakaoLogin()
      })
      .disposed(by: disposeBag)

    if #available(iOS 13.0, *) {
      appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
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
        } else if let accessToken = oauthToken?.idToken {
          print("카카오톡 로그인 성공: \(accessToken)")
          self.sendKakaoAccessTokenToServer(accessToken: accessToken)
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()

        if let error = error {
          print("카카오 계정 로그인 에러: \(error.localizedDescription)")
          self.showAlert(title: "로그인 실패", message: "카카오 계정 로그인에 실패했습니다: \(error.localizedDescription)")
        } else if let accessToken = oauthToken?.idToken {
          print("카카오 계정 로그인 성공: \(accessToken)")
          self.sendKakaoAccessTokenToServer(accessToken: accessToken)
        }
      }
    }
  }

  private func sendKakaoAccessTokenToServer(accessToken: String) {
    activityIndicator.startAnimating()

    // TODO: - Remove
    do {
      let request = try authProvider.endpoint(.kakaoLogin(accessToken: accessToken)).urlRequest()

      print("--- HTTP Request Details (Print Only) ---")
      print("URL: \(request.url?.absoluteString ?? "N/A")")
      print("Method: \(request.httpMethod ?? "N/A")")
      print("Headers: \(request.allHTTPHeaderFields ?? [:])")

      if let httpBody = request.httpBody {
        if let jsonString = String(data: httpBody, encoding: .utf8) {
          print("Body (JSON): \(jsonString)")
        } else {
          print("Body (Data): \(httpBody as NSData)") // JSON이 아니거나 인코딩 실패 시
        }
      } else {
        print("Body: (None)")
      }
      print("--- End HTTP Request Details ---")

    } catch {
      print("Error getting URLRequest for debugging: \(error.localizedDescription)")
    }



    authProvider.rx.request(.kakaoLogin(accessToken: accessToken))
      .filterSuccessfulStatusCodes()
      .map(ApiResponse<LoginResult>.self)
      .subscribe(onSuccess: { [weak self] response in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()
        print("카카오 토큰 서버 응답: \(response)")

        if response.code == "SUCCESS", let loginResult = response.result {
          let serverAccessToken = loginResult.tokenResponse.accessToken
          let serverRefreshToken = loginResult.tokenResponse.refreshToken
          let userInfo = loginResult.user
          let isNewUser = loginResult.isNew

          print("서버에서 받은 AccessToken (카카오): \(serverAccessToken)")
          print("서버에서 받은 RefreshToken (카카오): \(serverRefreshToken)")
          print("사용자 정보 (카카오): ID: \(userInfo.id), 닉네임: \(userInfo.nickname), 이메일: \(userInfo.email ?? "없음"), 제공자: \(userInfo.provider)")
          print("새로운 사용자 여부 (카카오): \(isNewUser)")

          self.navigateToNextScreen(isNew: isNewUser)
        } else {
          self.showAlert(title: "서버 응답 오류", message: "카카오 로그인 서버 응답 오류: \(response)")
        }
      }, onFailure: { [weak self] error in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()
        print("카카오 토큰 서버 전송 에러: \(error.localizedDescription)")

        // MARK: 에러 타입에 따라 더 자세한 정보 출력
        if let moyaError = error as? MoyaError {
          switch moyaError {
          case .statusCode(let response):
            print("HTTP 상태 코드 오류: \(response.statusCode)")
            if let responseString = try? response.mapString() {
              print("서버 오류 응답 데이터: \(responseString)")
            }
          case .jsonMapping(let response):
            print("JSON 매핑 오류 (응답 데이터 파싱 실패): \(response.statusCode)")
            if let responseString = try? response.mapString() {
              print("JSON 매핑 실패 데이터: \(responseString)")
            }
          default:
            print("기타 Moya 에러: \(moyaError.localizedDescription)")
          }
        } else {
          print("카카오 토큰 서버 전송 에러 (기타): \(error.localizedDescription)")
        }

        self.showAlert(title: "로그인 실패", message: "카카오 로그인 중 서버 통신에 실패했습니다: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
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

      sendAppleIDTokenToServer(idToken: idToken)

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

  // MARK: Apple ID Token 서버 전송
  private func sendAppleIDTokenToServer(idToken: String) {
    activityIndicator.startAnimating()
    authProvider.rx.request(.appleLogin(idToken: idToken, user: ""))
      .filterSuccessfulStatusCodes()
    // MARK: map(ApiResponse<LoginResult>.self)로 변경
      .map(ApiResponse<LoginResult>.self) // 변경된 최상위 모델 사용
      .subscribe(onSuccess: { [weak self] response in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()
        print("애플 ID 토큰 서버 응답: \(response)")

        if response.code == "SUCCESS", let loginResult = response.result { // 응답 코드 및 result 필드 확인
          let serverAccessToken = loginResult.tokenResponse.accessToken
          let serverRefreshToken = loginResult.tokenResponse.refreshToken
          let userInfo = loginResult.user
          let isNewUser = loginResult.isNew

          print("서버에서 받은 AccessToken (애플): \(serverAccessToken)")
          print("서버에서 받은 RefreshToken (애플): \(serverRefreshToken)")
          print("사용자 정보 (애플): ID: \(userInfo.id), 닉네임: \(userInfo.nickname), 이메일: \(userInfo.email ?? "없음"), 제공자: \(userInfo.provider)")
          print("새로운 사용자 여부 (애플): \(isNewUser)")

          self.navigateToNextScreen(isNew: isNewUser)
        } else {
          let errorMessage =  "알 수 없는 서버 응답 오류"
          self.showAlert(title: "서버 응답 오류", message: "애플 로그인 서버 응답 오류: \(errorMessage)")
        }
      }, onFailure: { [weak self] error in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()
        print("애플 ID 토큰 서버 전송 에러: \(error.localizedDescription)")
        self.showAlert(title: "로그인 실패", message: "애플 로그인 중 서버 통신에 실패했습니다: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
