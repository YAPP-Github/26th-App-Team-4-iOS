//
//  RecordListTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//


import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain
import Kingfisher

public class RecordListTableCell: BaseTableViewCell {
  
  private lazy var rootContainerStackView = UIStackView(
    arrangedSubviews: [
      titleWithImageStack,
      paceTimeStack
    ]
  ).then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.spacing = 16
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
  }
  
  private lazy var titleWithImageStack = UIStackView(
    arrangedSubviews: [titleWithDistanceStack, UIView(), CourseImageView]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 12
    $0.alignment = .fill
  }
  
  private lazy var titleWithDistanceStack = UIStackView(
    arrangedSubviews: [titleLabel, distanceStack]
  ).then {
    $0.axis = .vertical
    $0.spacing = 2
    $0.alignment = .leading
  }
  
  private let titleLabel = UILabel().then { // 20
    $0.text = "m월 dd일 시간 러닝"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.secondary
  }
  
  private lazy var distanceStack = UIStackView(
    arrangedSubviews: [distanceLabel, kmLabel, UIView()]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 2
    $0.alignment = .center
  }
  
  private let distanceLabel = UILabel().then { // 36
    $0.text = "86.3"
    $0.font = .systemFont(ofSize: 28, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private let kmLabel = UILabel().then { // 28
    $0.text = "km"
    $0.font = .systemFont(ofSize: 18, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private let CourseImageView = UIImageView().then {
    $0.backgroundColor = UIColor(hex: "#D9D9D9")
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private lazy var paceTimeStack = UIStackView(
    arrangedSubviews: [paceStack, timeStack]
  ).then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  private lazy var paceStack = UIStackView(
    arrangedSubviews: [paceTitleLabel, paceValueLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .fill
  }
  
  private let paceTitleLabel = UILabel().then {
    $0.text = "평균 페이스"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let paceValueLabel = UILabel().then { // 24
    $0.text = "n'nn\""
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private lazy var timeStack = UIStackView(
    arrangedSubviews: [timeTitleLabel, timeValueLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .fill
  }
  
  private let timeTitleLabel = UILabel().then {
    $0.text = "러닝 시간"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private let timeValueLabel = UILabel().then { // 24
    $0.text = "hh:mm:ss"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  func setData(
    title: String,
    distance: Double,
    pace: TimeInterval,
    time: TimeInterval,
    imageURL: String?
  ) {
    titleLabel.text = title
    distanceLabel.text = String(format: "%.1f", distance)
    paceValueLabel.text = pace.minuteSecondFormatted
    timeValueLabel.text = time.hourMinuteSecondFormatted
    
    if let url = URL(string: imageURL ?? "") {
      CourseImageView.kf.setImage(with: url)
    } else {
      CourseImageView.image = nil
    }
  }
  
  public override func initUI() {
    super.initUI()
    contentView.backgroundColor = FRColor.Bg.secondary

    contentView.addSubview(rootContainerStackView)
    rootContainerStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().inset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.height.equalTo(36)
    }
    
    kmLabel.snp.makeConstraints {
      $0.height.equalTo(28)
    }

    CourseImageView.snp.makeConstraints {
      $0.width.equalTo(CourseImageView.snp.height).multipliedBy(1.33)
    }
    
    paceTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    paceValueLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    timeTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    timeValueLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
  }
}
