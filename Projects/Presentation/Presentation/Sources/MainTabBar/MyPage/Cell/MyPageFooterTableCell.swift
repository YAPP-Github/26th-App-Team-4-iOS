//
//  MyPageFooterTableCell.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import Domain

class MyPageFooterTableCell: BaseTableViewCell {
  
  private lazy var rootVStack = UIStackView(
    arrangedSubviews: [appTitleImageView, emailLabel]
  ).then { // 24
    $0.axis = .vertical
    $0.spacing = 18
    $0.alignment = .center
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 80, left: 0, bottom: 80, right: 0)
  }

  private let appTitleImageView = UIImageView(
    image: UIImage(named: "AppTitle", in: Bundle.module, compatibleWith: nil)
  ).then {
    $0.contentMode = .scaleAspectFill
    $0.tintColor = FRColor.Fg.Icon.secondary
  } // 24
  
  private let emailLabel = UILabel().then { // 24
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = FRColor.Fg.Text.primary.withAlphaComponent(0.4)
    $0.text = "sample@gmail.com"
  }

  public override func initUI() {
    super.initUI()
    contentView.backgroundColor = FRColor.Bg.secondary
    
    contentView.addSubview(rootVStack)
    rootVStack.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    appTitleImageView.snp.makeConstraints {
      $0.width.equalTo(82)
      $0.height.equalTo(22)
    }
  }
}
