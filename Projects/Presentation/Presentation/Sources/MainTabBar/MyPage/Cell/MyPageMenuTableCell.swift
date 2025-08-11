//
//  MyPageMenuTableCell.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import Domain

class MyPageMenuTableCell: BaseTableViewCell {
  
  private let containerView = UIView().then { // 24
    $0.backgroundColor = FRColor.Bg.primary
  }

  private let titleLabel = UILabel().then { // 24
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "러닝 설정"
  }

  private let arrowButtonImageView = UIImageView(image: .init(systemName: "chevron.right")).then {
    $0.contentMode = .scaleAspectFill
    $0.tintColor = FRColor.Fg.Icon.secondary
  } // 24
  
  private let versionLabel = UILabel().then { // 24
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.text = "러닝 설정"
    $0.isHidden = true
  }
  
  public override func initUI() {
    super.initUI()
    contentView.backgroundColor = FRColor.Bg.secondary
    
    contentView.addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.height.equalTo(60)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.bottom.equalToSuperview()
    }
    
    containerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
    
    containerView.addSubview(arrowButtonImageView)
    arrowButtonImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
    
    containerView.addSubview(versionLabel)
    versionLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
  }
}
