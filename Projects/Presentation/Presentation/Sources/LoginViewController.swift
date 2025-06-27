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
import Moya
import KakaoSDKAuth
import KakaoSDKUser

public final class LoginViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let loginResult = PublishRelay<String>()
  
  private let appleLoginButton = UIButton().then {
    $0.setTitle("Sign in with Apple", for: .normal)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 8
  }
  
  private let kakaoLoginButton = UIButton().then {
    $0.setTitle("Sign in with Kakao", for: .normal)
    $0.backgroundColor = UIColor(red: 0.996, green: 0.871, blue: 0.000, alpha: 1)
    $0.setTitleColor(.black, for: .normal)
    $0.layer.cornerRadius = 8
  }
  
  private let provider = MoyaProvider<LoginAPI>()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
    bindUI()
  }
  
  private func setupUI() {
    view.addSubview(appleLoginButton)
    view.addSubview(kakaoLoginButton)
    
    appleLoginButton.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.equalTo(50)
      $0.left.right.equalToSuperview().inset(40)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(appleLoginButton.snp.bottom).offset(20)
      $0.left.right.height.equalTo(appleLoginButton)
    }
  }
  
  private func bindUI() {
    appleLoginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.performAppleLogin()
      })
      .disposed(by: disposeBag)
    
    kakaoLoginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.performKakaoLogin()
      })
      .disposed(by: disposeBag)
    
    loginResult
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] message in
        self?.showAlert(title: "로그인 성공", message: message)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Apple Login
  
  private func performAppleLogin() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
  
  // MARK: - Kakao Login
  
  private func performKakaoLogin() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
        if let error = error {
          self?.showAlert(title: "카카오 로그인 실패", message: error.localizedDescription)
          return
        }
        guard let token = oauthToken?.accessToken else {
          self?.showAlert(title: "카카오 로그인 실패", message: "토큰을 받지 못했습니다.")
          return
        }
        self?.sendAccessTokenToServer(token: token)
          .observe(on: MainScheduler.instance)
          .subscribe(onSuccess: { result in
            self?.loginResult.accept(result)
          }, onFailure: { error in
            self?.showAlert(title: "서버 인증 실패", message: error.localizedDescription)
          })
          .disposed(by: self!.disposeBag)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
        if let error = error {
          self?.showAlert(title: "카카오 로그인 실패", message: error.localizedDescription)
          return
        }
        guard let token = oauthToken?.accessToken else {
          self?.showAlert(title: "카카오 로그인 실패", message: "토큰을 받지 못했습니다.")
          return
        }
        self?.sendAccessTokenToServer(token: token)
          .observe(on: MainScheduler.instance)
          .subscribe(onSuccess: { result in
            self?.loginResult.accept(result)
          }, onFailure: { error in
            self?.showAlert(title: "서버 인증 실패", message: error.localizedDescription)
          })
          .disposed(by: self!.disposeBag)
      }
    }
  }
  
  // MARK: - Server API Call
  
  private func sendAccessTokenToServer(token: String) -> Single<String> {
    return Single.create { [provider] single in
      provider.request(.socialLogin(name: "name", email: "email")) { result in
        switch result {
        case .success(let response):
          if (200...299).contains(response.statusCode) {
            do {
              let decoded = try JSONDecoder().decode(UserResponse.self, from: response.data)
              print("✅ 로그인 성공, 사용자 이름: \(decoded.result)")
              single(.success("서버 인증 성공"))
            } catch {
              print("❌ 디코딩 실패:", error)
              single(.failure(error))
            }
          } else {
            single(.failure(NSError(domain: "ServerError", code: response.statusCode, userInfo: nil)))
          }
          
        case .failure(let error):
          single(.failure(error))
        }
      }
      
      return Disposables.create()
    }
  }
  
  // MARK: - Helper
  
  private func showAlert(title: String, message: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(.init(title: "확인", style: .default))
      self.present(alert, animated: true)
    }
  }
}

// MARK: - Apple Login Delegates

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let tokenData = credential.identityToken,
          let token = String(data: tokenData, encoding: .utf8) else {
      showAlert(title: "애플 로그인 실패", message: "토큰을 받지 못했습니다.")
      return
    }
    
    sendAccessTokenToServer(token: token)
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] result in
        self?.loginResult.accept(result)
      }, onFailure: { [weak self] error in
        self?.showAlert(title: "서버 인증 실패", message: error.localizedDescription)
      })
      .disposed(by: disposeBag)
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    showAlert(title: "애플 로그인 실패", message: error.localizedDescription)
  }
  
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return view.window ?? ASPresentationAnchor()
  }
}

// MARK: - Moya TargetType

enum LoginAPI {
  case socialLogin(name: String, email: String)
}

extension LoginAPI: TargetType {
  var baseURL: URL { URL(string: "http://fitrun.p-e.kr")! }
  var path: String {
    switch self {
    case .socialLogin:
      return "/api/users"
    }
  }
  var method: Moya.Method {
    switch self {
    case .socialLogin:
      return .post
    }
  }
  var task: Task {
    switch self {
    case .socialLogin(let name, let email):
      return .requestParameters(parameters: ["name": name, "email": email], encoding: JSONEncoding.default)
    }
  }
  var headers: [String : String]? {
    ["Content-Type": "application/json"]
  }
}

struct UserResponse: Codable {
  let code: String
  let result: User
  let timeStamp: String
}

struct User: Codable {
  let id: Int
  let name: String
  let email: String
  let isDeleted: Bool
}
