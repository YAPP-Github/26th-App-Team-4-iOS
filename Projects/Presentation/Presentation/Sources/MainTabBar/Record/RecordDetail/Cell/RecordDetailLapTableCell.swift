//
//  RecordDetailLapTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import SnapKit
import Core
import ReactorKit
import Domain

public class RecordDetailLapTableCell: BaseTableViewCell {
  
  private var pendingScale: CGFloat = 0
  private var graphWidthConstraint: Constraint!

  private lazy var rootStack = UIStackView(arrangedSubviews: [lapNumberLabel, lapTimeGraphView, UIView()]).then {
    $0.axis = .horizontal
    $0.spacing = 0
    $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.alignment = .fill
    $0.backgroundColor = .white
  }
  
  private let lapNumberLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
    
  private let lapTimeGraphView = UIView().then {
    $0.layer.cornerRadius = 10
    $0.backgroundColor = UIColor(hex: "B0B3BA")
  }
  
  private let lapTimeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = .white
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
    
    lapTimeGraphView.snp.makeConstraints { make in
      make.height.equalTo(44)
      graphWidthConstraint = make.width.equalTo(0).constraint
    }
    
    lapTimeGraphView.addSubview(lapTimeLabel)
    lapTimeLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
    }
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    // contentView.bounds.width 가 확실히 계산된 뒤에야 호출됨
    let maxWidth = contentView.bounds.width - 135
    graphWidthConstraint.update(offset: maxWidth * pendingScale)
  }
  
  public func setData(
    lapNumber: Int,
    lapTime: String,
    length: CGFloat,
    isPrimary: Bool
  ) {
    lapNumberLabel.text = "\(lapNumber)"
    lapTimeLabel.text   = lapTime
    lapTimeGraphView.backgroundColor = isPrimary
      ? UIColor(hex: "FF6600")
      : UIColor(hex: "B0B3BA")
    
    // updateConstraints 를 다시 쓰지 않고, pendingScale 만 바꿔두고 레이아웃 사이클을 트리거
    pendingScale = length
    
    // 레이아웃 갱신
    contentView.setNeedsLayout()
    contentView.layoutIfNeeded()
  }
}
