//
//  RecordDetailAchievementTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public class RecordDetailAchievementTableCell: BaseTableViewCell {
  
  private lazy var rootStack = UIStackView(
    arrangedSubviews: [
      achievementImageView,
      achievementTitleLabel,
    ]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layer.cornerRadius = 12
    $0.backgroundColor = .white
  }
  
  private let achievementImageView = UIImageView().then { // 14, 24
    $0.image = UIImage(named: "GoalAchievement", in: Bundle.module, compatibleWith: nil)
    $0.contentMode = .scaleAspectFit
  }
  
  private let achievementTitleLabel = UILabel().then { // 20
    $0.text = "페이스, 거리, 시간 목표를 달성했어요! "
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  public override func initUI() {
    super.initUI()
    
    contentView.backgroundColor = .clear

    contentView.addSubview(rootStack)
    rootStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(28)
      $0.height.equalTo(48)
    }
    
    achievementImageView.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.width.equalTo(14)
    }
  }
}
