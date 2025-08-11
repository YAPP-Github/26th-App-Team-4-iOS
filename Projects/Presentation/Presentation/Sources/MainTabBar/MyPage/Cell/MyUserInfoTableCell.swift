//
//  MyUserInfoTableCell.swift
//  Presentation
//
//  Created by JDeoks on 8/11/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public class MyUserInfoTableCell: BaseTableViewCell {
  
  // MARK: - 루트 스택
  
  private lazy var rootContainerStackView = UIStackView(
    arrangedSubviews: [topHStack, separatorView, healthAndGoalHStack]
  ).then {
    $0.axis = .vertical
    $0.backgroundColor = FRColor.Bg.Interactive.secondary
    $0.layer.cornerRadius = 16
  }
  
  // MARK: - 위쪽 유저 정보
  private lazy var topHStack = UIStackView( // 88
    arrangedSubviews: [userInfoVStack, UIView(), arrowButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .center
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
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
    $0.textColor = FRColor.Fg.Text.Interactive.inverse
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
  
  private let arrowButton = UIButton(type: .system).then { //  24
    $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    $0.tintColor = FRColor.Fg.Icon.secondary
  }
  
  // MARK: - 구분선
  private let separatorView = UIView().then { //  1
    $0.backgroundColor = FRColor.Fg.Nuetral.gray800
  }
  
  // MARK: - 체력수준 & 러닝 목표 컨테이너
  private lazy var healthAndGoalHStack = UIStackView(
    arrangedSubviews: [healthLevelHStack, goalHStack]
  ).then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  // MARK: - 체력수준
  private lazy var healthLevelHStack = UIStackView(
    arrangedSubviews: [healthLevelImageLabel, healthLevelTextVStack, UIView()]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 20, right: 16)
  }
  
  private let healthLevelImageLabel = UILabel().then { //  28
    $0.text = "🐣"
    $0.font = .systemFont(ofSize: 28, weight: .medium)
  }
  
  private lazy var healthLevelTextVStack = UIStackView( //  20
    arrangedSubviews: [healthLevelLabel, healthLevelValueLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 2
    $0.alignment = .leading
  }
  
  private let healthLevelLabel = UILabel().then { //  20
    $0.text = "체력수준"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let healthLevelValueLabel = UILabel().then { //  20
    $0.text = "워밍업 러너"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.Interactive.inverse
  }

  // MARK: - 러닝 목표
  private lazy var goalHStack = UIStackView(
    arrangedSubviews: [goalImageLabel, goalTextVStack, UIView()]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 20, right: 16)
  }
  
  private let goalImageLabel = UILabel().then { //  28
    $0.text = "🔥"
    $0.font = .systemFont(ofSize: 28, weight: .medium)
  }
  
  private lazy var goalTextVStack = UIStackView( //  20
    arrangedSubviews: [goalLabel, goalValueLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 2
    $0.alignment = .leading
  }
  
  private let goalLabel = UILabel().then { //  20
    $0.text = "체력 수준"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let goalValueLabel = UILabel().then { //  20
    $0.text = "워밍업 러너"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.Interactive.inverse
  }
  
  
  public override func initUI() {
    super.initUI()
    
    contentView.backgroundColor = FRColor.Bg.secondary
    
    contentView.addSubview(rootContainerStackView)
    rootContainerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    authProviderImageView.snp.makeConstraints {
      $0.width.height.equalTo(22)
    }
    
    arrowButton.snp.makeConstraints {
      $0.width.height.equalTo(24)
    }
    
    separatorView.snp.makeConstraints {
      $0.height.equalTo(1)
    }
    
    healthAndGoalHStack.snp.makeConstraints {
      $0.height.equalTo(74)
    }
    
    healthLevelImageLabel.snp.makeConstraints {
      $0.width.height.equalTo(28)
    }
    
    goalImageLabel.snp.makeConstraints {
      $0.width.height.equalTo(28)
    }
  }
  
}
