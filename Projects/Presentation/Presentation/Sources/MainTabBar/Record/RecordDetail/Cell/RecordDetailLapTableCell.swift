//
//  RecordDetailLapTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public class RecordDetailLapTableCell: BaseTableViewCell {
  
  private lazy var rootStack = UIStackView(
    arrangedSubviews: [lapNumberLabel, lapTimeGraphView]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 0
    $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.alignment = .fill
    $0.backgroundColor = .white
  }
  
  private let lapNumberLabel = UILabel().then { // 55
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.textColor = FRColor.FG.Text.primary
    $0.text = "1"
  }
    
  private let lapTimeGraphView = UIView().then {
    $0.layer.cornerRadius = 10
    $0.backgroundColor = UIColor(hex: "B0B3BA")
  }
  
  let lapTimeLabel = UILabel().then { // 24
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = .white
    $0.text = "5'23\""
  }
  
  public override func initUI() {
    super.initUI()
    
    contentView.addSubview(rootStack)
    rootStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    lapNumberLabel.snp.makeConstraints {
      $0.width.equalTo(55)
    }
    
    lapTimeGraphView.snp.makeConstraints {
      $0.height.equalTo(44)
    }

    lapTimeGraphView.addSubview(lapTimeLabel)
    lapTimeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
    
    lapTimeGraphView.snp.makeConstraints {
      $0.width.equalTo(200)
    }
  }
}
