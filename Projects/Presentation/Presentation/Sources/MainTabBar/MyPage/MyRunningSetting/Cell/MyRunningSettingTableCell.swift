//
//  MyRunningSettingTableCell.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public class MyRunningSettingTableCell: BaseTableViewCell {
  
  // MARK: - 루트 스택
  lazy var RootHStack = UIStackView( // 88
    arrangedSubviews: [TextVStack, UIView(), toggleSwitch]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .center
  }
  
  lazy var TextVStack = UIStackView( // 88
    arrangedSubviews: [titleLabel, descLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .leading
  }
  
  private let titleLabel = UILabel().then { // 24
    $0.text = "오디오 코칭"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private let descLabel = UILabel().then { // 20
    $0.text = "러닝 중 올바른 자세에 대한 안내가 음성으로 제공되는 기능이에요"
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = FRColor.Fg.Text.secondary
    $0.numberOfLines = 0
  }
  
  private let toggleSwitch = UISwitch().then { // 24
    $0.onTintColor = FRColor.Fg.Text.primary
    $0.isOn = false
    $0.isUserInteractionEnabled = false
  }
  
  func setData(title: String, desc: String, isOn: Bool) {
    titleLabel.text = title
    descLabel.text = desc
    toggleSwitch.isOn = isOn
  }
  
  public override func initUI() {
    super.initUI()
    
    contentView.backgroundColor = FRColor.Bg.primary
    
    contentView.addSubview(RootHStack)
    RootHStack.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-10)
    }
    
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
  }
}
  
