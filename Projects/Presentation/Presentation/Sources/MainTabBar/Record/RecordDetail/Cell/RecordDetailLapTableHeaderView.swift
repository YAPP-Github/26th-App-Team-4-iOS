//
//  RecordDetailLapTableHeaderView.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//


import UIKit
import Core
import ReactorKit
import Domain

public class RecordDetailLapTableHeaderView: BaseView {
  private lazy var rootStackView = UIStackView(
    arrangedSubviews: [lapLabel, kmPaceStackView]
  ).then { // 16
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 20
    $0.backgroundColor = .white
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    $0.layer.cornerRadius = 16
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  public let lapLabel = UILabel().then { // 24
    $0.text = "랩 구간"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = .black
  }
  
  private lazy var kmPaceStackView = UIStackView(
    arrangedSubviews: [kmLabel, paceLabel, UIView()]
  ).then { // 16
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fill
    $0.spacing = 0
  }
  
  public let kmLabel = UILabel().then { // 20
    $0.text = "km"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = FRColor.FG.Text.secondary
  }
  
  public let paceLabel = UILabel().then { // 20
    $0.text = "평균 페이스"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = FRColor.FG.Text.secondary
  }
  
  public override func initUI() {
    super.initUI()
    
    self.addSubview(rootStackView)
    rootStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    lapLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    kmPaceStackView.snp.makeConstraints {
      $0.height.equalTo(20)
    }
  }
}
