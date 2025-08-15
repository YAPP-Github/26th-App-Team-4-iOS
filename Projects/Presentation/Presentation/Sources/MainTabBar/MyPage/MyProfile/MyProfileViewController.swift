//
//  MyProfileViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public final class MyProfileViewController: BaseViewController, View {
  
  public typealias Reactor = MyProfileReactor
  
  var coordinator: MyPageCoordinator?

  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let navLabel = UILabel().then { // 20
    $0.text = "프로필"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private lazy var userInfoVStack = UIStackView(
    arrangedSubviews: [userNameHStack, emailLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
  }
  
  private lazy var userNameHStack = UIStackView( // 24
    arrangedSubviews: [userNameLabel, authProviderImageView]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
  }
  
  private let userNameLabel = UILabel().then { //  24
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "유저명"
  }
  
  private let authProviderImageView = UIImageView().then { //  22,22
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(named: "AppleLogo", in: Bundle.module, compatibleWith: nil)
    $0.layer.cornerRadius = 11
  }
  
  private let emailLabel = UILabel().then { //  20
    $0.font = .systemFont(ofSize: 13)
    $0.text = "usermail@gmail.com"
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let seperatorView = UIView().then {
    $0.backgroundColor = FRColor.Bg.secondary
  }
  
  private lazy var logOutVStack = UIStackView(
    arrangedSubviews: [logOutButtonLabel, deleteUserButtonLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .fill
    $0.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
  }
  
  let logOutButtonLabel = UILabel().then { //  24
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "로그아웃"
  }
  
  let deleteUserButtonLabel = UILabel().then { //  24
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "회원탈퇴"
  }
  
  let footerView = UIView().then {
    $0.backgroundColor = FRColor.Bg.secondary
  }
  
  override init() {
    super.init()
    hidesBottomBarWhenPushed = true
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func initUI() {
    super.initUI()
    view.backgroundColor = FRColor.Bg.primary
    
    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(24)
    }
    
    view.addSubview(navLabel)
    navLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(56)
    }
    
    view.addSubview(userInfoVStack)
    userInfoVStack.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(navLabel.snp.bottom).offset(24)
    }
    
    authProviderImageView.snp.makeConstraints {
      $0.width.height.equalTo(22)
    }
    
    view.addSubview(seperatorView)
    seperatorView.snp.makeConstraints {
      $0.top.equalTo(userInfoVStack.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(8)
    }
    
    view.addSubview(logOutVStack)
    logOutVStack.snp.makeConstraints {
      $0.top.equalTo(seperatorView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    logOutButtonLabel.snp.makeConstraints {
      $0.height.equalTo(56)
    }
    
    deleteUserButtonLabel.snp.makeConstraints {
      $0.height.equalTo(56)
    }
    
    view.addSubview(footerView)
    footerView.snp.makeConstraints {
      $0.top.equalTo(logOutVStack.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  public func bind(reactor: MyProfileReactor) {
    print("\(type(of: self)) - \(#function)")

    self.rx.viewDidLoad
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.profileInfo)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .distinctUntilChanged()
      .subscribe(with: self) { owner, userInfo in
        owner.setUserinfo(userInfo)
      }
      .disposed(by: disposeBag)
  }
  
  private func setUserinfo(_ userInfo: Domain.ProfileInfo) {
    userNameLabel.text = userInfo.nickname
    emailLabel.text = userInfo.email
  }
  
  public override func action() {
    super.action()
    
    backButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    deleteUserButtonLabel.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        owner.coordinator?.showDeleteAccount(mode: .deleteAccountTerm)
      }
      .disposed(by: disposeBag)
  }
}
