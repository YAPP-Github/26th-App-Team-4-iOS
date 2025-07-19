//
//  WeeklyRunningGoalCardView.swift
//  Presentation
//
//  Created by JDeoks on 7/18/25.
//


import UIKit
import ReactorKit

import Core
import Domain

public class WeeklyRunningGoalCardView: BaseView {
  
  private lazy var titleStackView = UIStackView(
    arrangedSubviews: [titleLabel, UIView(), editButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.alignment = .center
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "🔥 이번주 러닝 목표"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = .black
  }

  let editButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "pencil"), for: .normal)
    $0.tintColor = .gray
  }

  private let progressView = UIProgressView(progressViewStyle: .bar).then {
    $0.trackTintColor = UIColor.systemGray3
    $0.progressTintColor = UIColor.systemGray5
    $0.layer.cornerRadius = 1
    $0.clipsToBounds = true
    $0.progress = 0.5
  }
  
  private lazy var recordContainerStackView = UIStackView(
    arrangedSubviews: [targetContainerStackView, recentContainerStackView]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.clipsToBounds = true
    $0.spacing = 9
  }

  private lazy var targetContainerStackView = UIStackView(
    arrangedSubviews: [targetTitleLabel, UIView(), targetValueLabel]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.backgroundColor = UIColor(red: 0.99, green: 0.95, blue: 0.92, alpha: 1)
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private let targetTitleLabel = UILabel().then {
    $0.text = "목표 페이스"
    $0.font = .systemFont(ofSize: 10)
    $0.textColor = UIColor.systemGray
  }

  private let targetValueLabel = UILabel().then {
    $0.text = "--'--\""
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .right
  }
  
  private lazy var recentContainerStackView = UIStackView(
    arrangedSubviews: [recentTitleLabel, UIView(), recentValueLabel]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.backgroundColor = UIColor(red: 1, green: 0.97, blue: 0.97, alpha: 1)
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private let recentTitleLabel = UILabel().then {
    $0.text = "최근 페이스"
    $0.font = .systemFont(ofSize: 10)
    $0.textColor = UIColor.systemGray
  }

  private let recentValueLabel = UILabel().then {
    $0.text = "--'--\""
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .right
  }
  
  public func setData(_ homeInfo: HomeInfo) {
    // 목표 페이스
    if let paceGoal = homeInfo.paceGoal {
      let paceSec = Int(paceGoal)
      let minutesT = paceSec / 60
      let secondsT = paceSec % 60
      targetValueLabel.text = "\(minutesT)'\(String(format: "%02d", secondsT))\""
    } else {
      targetValueLabel.text = "-’--”"
    }

    // 최근 페이스
    if let recentPace = homeInfo.recentPace {
      let paceSec = Int(recentPace)
      let minutesR = paceSec / 60
      let secondsR = paceSec % 60
      recentValueLabel.text = "\(minutesR)'\(String(format: "%02d", secondsR))\""
    } else {
      recentValueLabel.text = "-’--”"
    }

    // 진행도 계산 (옵셔널 처리)
    let weekly = homeInfo.weeklyRunningCount ?? 0
    let thisCount = homeInfo.thisWeekRunningCount ?? 0
    let progress: Float = weekly > 0
      ? Float(thisCount) / Float(weekly)
      : 0

    progressView.progress = min(max(progress, 0), 1)
  }

  
  public override func initUI() {
    super.initUI()
    backgroundColor = FRColor.BG.primary
    layer.cornerRadius = 12
    addShadow()
    
    addSubview(titleStackView)
    titleStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(24)
    }
    
    addSubview(progressView)
    progressView.snp.makeConstraints {
      $0.top.equalTo(titleStackView.snp.bottom).offset(11)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(4)
    }
    
    addSubview(recordContainerStackView)
    recordContainerStackView.snp.makeConstraints {
      $0.top.equalTo(progressView.snp.bottom).offset(17)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(38)
      $0.bottom.equalToSuperview().inset(18)
    }
  }
}
