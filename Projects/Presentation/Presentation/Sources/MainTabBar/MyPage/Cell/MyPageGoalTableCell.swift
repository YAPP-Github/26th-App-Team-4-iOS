//
//  MyPageGoalTableCell.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import Domain

class MyPageGoalTableCell: BaseTableViewCell {
  
  private lazy var rootHStack = UIStackView(
    arrangedSubviews: [iconImageContainerView, textVStack, UIView(), arrowButtonImageView]
  ).then { // 24
    $0.backgroundColor = FRColor.Bg.primary
    $0.axis = .horizontal
    $0.spacing = 12
    $0.alignment = .center
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 20)
  }

  private let iconImageContainerView = UIView().then {
    $0.backgroundColor = FRColor.Bg.secondary
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
  }
  
  private let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private lazy var textVStack = UIStackView(
    arrangedSubviews: [titleLabel, valueLabel]
  ).then { // 24
    $0.axis = .vertical
    $0.spacing = 2
    $0.alignment = .leading
  }
  
  private let titleLabel = UILabel().then { // 20
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.text = "목표 거리"
  }
  
  private let valueLabel = UILabel().then { // 24
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.disabled
    $0.text = "설정되지 않았어요"
  }
  
  private let arrowButtonImageView = UIImageView(
    image: UIImage(named: "chevron_right", in: Bundle.module, compatibleWith: nil)
  ).then {
    $0.contentMode = .scaleAspectFill
    $0.tintColor = FRColor.Fg.Icon.secondary
  } // 24
  
  
  func setData(item: MyPageViewController.Item, value: String) {
    iconImageView.image = item.image
    titleLabel.text = item.title
    valueLabel.text = value
  }
  
  public override func initUI() {
    super.initUI()
    contentView.backgroundColor = FRColor.Bg.secondary
    
    contentView.addSubview(rootHStack)
    rootHStack.snp.makeConstraints {
      $0.height.equalTo(56)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    iconImageContainerView.addSubview(iconImageView)
    iconImageContainerView.snp.makeConstraints {
      $0.width.height.equalTo(44)
    }
    
    iconImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    arrowButtonImageView.snp.makeConstraints {
      $0.size.equalTo(24)
    }
  }
}
