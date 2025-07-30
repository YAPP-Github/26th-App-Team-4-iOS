//
//  RecordDetailRecordTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//


import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public class RecordDetailRecordTableCell: BaseTableViewCell {
  
  private lazy var rootStack = UIStackView(
    arrangedSubviews: [distanceHStack, paceTimeHStack]
  ).then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layer.cornerRadius = 16
    $0.backgroundColor = .white
  }
  
  private lazy var distanceHStack = UIStackView(
    arrangedSubviews: [distanceValueLabel, kmLabel, UIView()]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 2
    $0.alignment = .bottom
  }

  private let distanceValueLabel = UILabel().then { //56
    $0.font = .systemFont(ofSize: 48, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "5.0"
  }
  
  private let kmLabel = UILabel().then { // 30
    $0.font = .systemFont(ofSize: 28, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "km"
  }
  
  private lazy var paceTimeHStack = UIStackView(
    arrangedSubviews: [paceVStack, runningTimeVStack]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  private lazy var paceVStack = UIStackView(
    arrangedSubviews: [paceTitleLabel, paceValueLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .leading
  }
  
  private let paceTitleLabel = UILabel().then { //20
    $0.text = "페이스"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let paceValueLabel = UILabel().then { //24
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "5'00\""
  }
  
  private lazy var runningTimeVStack = UIStackView(
    arrangedSubviews: [runningTimeTitleLabel, runningTimeValueLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .leading
  }
  
  private let runningTimeTitleLabel = UILabel().then { //20
    $0.text = "러닝 시간"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let runningTimeValueLabel = UILabel().then { //24
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.text = "hh:mm:ss"
  }
  
  public override func initUI() {
    super.initUI()
    
    contentView.backgroundColor = FRColor.Fg.Nuetral.gray0
    contentView.addSubview(rootStack)
    
    rootStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(28)
    }

    distanceValueLabel.snp.makeConstraints {
      $0.height.equalTo(56)
    }
    kmLabel.snp.makeConstraints {
      $0.height.equalTo(44)
    }
    paceTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    paceValueLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    runningTimeTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    runningTimeValueLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
  }
}
