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

public class SummaryTableViewCell: BaseTableViewCell {
  
  private lazy var rootContainerStackView = UIStackView(
    arrangedSubviews: [
      distanceWithTitleStack,
      statsStack,
      goalAchieveContainerStack
    ]
  ).then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.spacing = 16
  }
  
  private lazy var distanceWithTitleStack = UIStackView(
    arrangedSubviews: [distanceTitleLabel, distanceStack]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .fill
  }
  
  private let distanceTitleLabel = UILabel().then { // 20
    $0.text = "총 러닝 거리"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  private lazy var distanceStack = UIStackView(
    arrangedSubviews: [distanceLabel, kmLabel]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 4
  }
  private let distanceLabel = UILabel().then { // 30
    $0.font = .systemFont(ofSize: 28, weight: .bold)
    $0.textColor = .black
  }
  private let kmLabel = UILabel().then { //30
    $0.font = .systemFont(ofSize: 28, weight: .semibold)
    $0.textColor = .black
    $0.text = "km"
  }
  
  private lazy var statsStack = UIStackView(
    arrangedSubviews: [
      runCountStack,
      runPaceStack,
      runTimeStack,
      UIView()
    ]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 24
  }
  
  // MARK: - 러닝 횟수
  private lazy var runCountStack = UIStackView(
    arrangedSubviews: [runCountTitleLabel, runCountNumStack]
  ).then {
    $0.axis = .vertical
    $0.alignment = .leading
  }
  
  private let runCountTitleLabel = UILabel().then { // 20
    $0.text = "러닝 횟수"
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  private lazy var runCountNumStack = UIStackView(
    arrangedSubviews: [runCountLabel, runCountCountLabel, UIView()]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .bottom
  }
  
  private let runCountLabel = UILabel().then { //24
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .center
    $0.text = "0"
  }
  
  private let runCountCountLabel = UILabel().then { //20
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = FRColor.FG.Text.primary
    $0.textAlignment = .center
    $0.text = "회"
  }
  
  // MARK: - 평균 페이스
  private lazy var runPaceStack = UIStackView(
    arrangedSubviews: [runPaceTitleLabel, runPaceLabel]
  ).then {
    $0.axis = .vertical
    $0.alignment = .leading
  }
  
  private let runPaceTitleLabel = UILabel().then { // 20
    $0.text = "평균 페이스"
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = FRColor.FG.Text.tertiary
  }

  private let runPaceLabel = UILabel().then { //24
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .center
    $0.text = "7'18"
  }
  
  // MARK: - 러닝 시간
  private lazy var runTimeStack = UIStackView(
    arrangedSubviews: [runTimeTitleLabel, runTimeLabel]
  ).then {
    $0.axis = .vertical
    $0.alignment = .leading
  }
  
  private let runTimeTitleLabel = UILabel().then { // 20
    $0.text = "러닝 시간"
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = FRColor.FG.Text.tertiary
  }

  private let runTimeLabel = UILabel().then { //24
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .center
    $0.text = "4:10:40"
  }
  
  // MARK: - 목표 달성 횟수
  private lazy var goalAchieveContainerStack = UIStackView(
    arrangedSubviews: [goalAchieveLabel, goalAchieveStatContainerStack]
  ).then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .fill
  }
  
  private let goalAchieveLabel = UILabel().then { // 20
    $0.text = "목표 달성 횟수"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  // MARK: - 목표 달성 전체 스택
  private lazy var goalAchieveStatContainerStack = UIStackView(
    arrangedSubviews: [goalDistanceTitleStack, separatorView, goalAchieveTimeStack]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 12
    $0.distribution = .fillEqually
  }
  
  /// 거리 컨테이너 스택
  private lazy var goalAchieveDistanceStack = UIStackView(
    arrangedSubviews: [goalDistanceTitleStack, UIView(), goalDistanceCountStack]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .bottom
  }

  /// 거리 타이틀 스택
  private lazy var goalDistanceTitleStack = UIStackView(
    arrangedSubviews: [goalDistanceImageView, goalDistanceTitleLabel]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
  }
  private let goalDistanceImageView = UIImageView().then { // 34
    $0.image = UIImage(named: "TrackIcon", in: Bundle.module, compatibleWith: nil)
  }
  private let goalDistanceTitleLabel = UILabel().then { // 20
    $0.text = "거리"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  /// 목표달성 거리 카운트 스택
  private lazy var goalDistanceCountStack = UIStackView(
    arrangedSubviews: [goalDistanceLabel, goalDistanceCountLabel]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
  }
  private let goalDistanceLabel = UILabel().then { // 20
    $0.text = "N"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  private let goalDistanceCountLabel = UILabel().then { // 20
    $0.text = "회"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = FRColor.FG.Text.tertiary.withAlphaComponent(0.8)
  }
  
  private let separatorView = UIView().then {
    $0.backgroundColor = UIColor(hex: "#EDEFF2")
  }
  
  /// 시간 컨테이너 스택
  private lazy var goalAchieveTimeStack = UIStackView(
    arrangedSubviews: [goalDistanceTitleStack, UIView(), goalDistanceCountStack]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .bottom
  }

  /// 시간 타이틀 스택
  private lazy var goalTimeTitleStack = UIStackView(
    arrangedSubviews: [goalDistanceImageView, goalDistanceTitleLabel]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
  }
  private let goalTimeImageView = UIImageView().then { // 34
    $0.image = UIImage(named: "ClockIcon", in: Bundle.module, compatibleWith: nil)
  }
  private let goalTimeTitleLabel = UILabel().then { // 20
    $0.text = "시간"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  /// 목표달성 시간 카운트 스택
  private lazy var goalTimeCountStack = UIStackView(
    arrangedSubviews: [goalDistanceLabel, goalDistanceCountLabel]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
  }
  private let goalTimeLabel = UILabel().then { // 20
    $0.text = "N"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  private let goalTimeCountLabel = UILabel().then { // 20
    $0.text = "회"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = FRColor.FG.Text.tertiary.withAlphaComponent(0.8)
  }
  
  public override func initUI() {
    super.initUI()
    contentView.backgroundColor = .white
    
    contentView.addSubview(rootContainerStackView)
    rootContainerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(26)
    }
    
    // MARK: - 총 러닝 거리
    distanceTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    distanceLabel.snp.makeConstraints {
      $0.height.equalTo(30)
    }
    kmLabel.snp.makeConstraints {
      $0.height.equalTo(30)
    }
    
    // MARK: - 러닝 횟수
    runCountTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    runCountLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    runCountCountLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    // MARK: - 평균 페이스
    runPaceTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    runPaceLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    // MARK: - 러닝 시간
    runTimeTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    runTimeLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    // MARK: - 목표 달성 횟수 거리 컨테이너 스택
    goalAchieveLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    goalDistanceImageView.snp.makeConstraints {
      $0.size.equalTo(34)
    }
    goalDistanceTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    // MARK: - 목표 달성 횟수 시간 컨테이너 스택
    goalTimeImageView.snp.makeConstraints {
      $0.size.equalTo(34)
    }
    goalTimeTitleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    goalTimeLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    goalTimeCountLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
  }
}
