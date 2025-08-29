//
//  WeeklyRunningGoalCardView.swift
//  Presentation
//
//  Created by JDeoks on 7/18/25.
//

import UIKit
import SnapKit
import ReactorKit

import Core
import Domain

public class WeeklyRunningGoalCardView: BaseView {
  
  // MARK: - UI
  
  private lazy var titleStackView = UIStackView(
    arrangedSubviews: [titleLabel, UIView(), editButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.alignment = .center
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "🔥 이번주 러닝 목표"
    $0.textColor = .black
    $0.apply(style: AppTypography.body3_bold)
  }

  let editButton = UIButton(type: .system).then {
    let image = UIImage(named: "EditPencil", in: .module, with: nil)?
      .resized(to: CGSize(width: 24, height: 24))
    $0.setImage(image, for: .normal)
    $0.tintColor = .gray
  }

  /// 기존 progressView 대신 사용할 스택뷰
  private let progressStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 2
    $0.layer.cornerRadius = 1
    $0.clipsToBounds = true
  }
  
  private lazy var recordContainerStackView = UIStackView(
    arrangedSubviews: [targetContainerStackView, recentContainerStackView]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.spacing = 9
  }

  private lazy var targetContainerStackView = UIStackView(
    arrangedSubviews: [targetTitleLabel, UIView(), targetValueLabel]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.backgroundColor = UIColor(red: 0.99, green: 0.95, blue: 0.92, alpha: 1)
    $0.layer.cornerRadius = 8
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private let targetTitleLabel = UILabel().then {
    $0.text = "목표 페이스"
    $0.font = .systemFont(ofSize: 10)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.apply(style: AppTypography.caption4_semibold)
  }

  private let targetValueLabel = UILabel().then {
    $0.text = "--'--\""
    $0.textColor = .black
    $0.textAlignment = .right
    $0.apply(style: AppTypography.caption3_semibold)
  }
  
  private lazy var recentContainerStackView = UIStackView(
    arrangedSubviews: [recentTitleLabel, UIView(), recentValueLabel]
  ).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.backgroundColor = UIColor(red: 1, green: 0.97, blue: 0.97, alpha: 1)
    $0.layer.cornerRadius = 8
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private let recentTitleLabel = UILabel().then {
    $0.text = "최근 페이스"
    $0.font = .systemFont(ofSize: 10)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.apply(style: AppTypography.caption4_semibold)
  }

  private let recentValueLabel = UILabel().then {
    $0.text = "--'--\""
    $0.textColor = .black
    $0.textAlignment = .right
    $0.apply(style: AppTypography.caption3_semibold)
  }
  
  // MARK: - Layout

  public override func initUI() {
    super.initUI()
    backgroundColor = FRColor.Bg.primary
    layer.cornerRadius = 12
    addShadow()
    
    addSubview(titleStackView)
    titleStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(24)
    }
    
    addSubview(progressStackView)
    progressStackView.snp.makeConstraints {
      $0.top.equalTo(titleStackView.snp.bottom).offset(11)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(4)
    }
    
    addSubview(recordContainerStackView)
    recordContainerStackView.snp.makeConstraints {
      $0.top.equalTo(progressStackView.snp.bottom).offset(17)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(38)
      $0.bottom.equalToSuperview().inset(18)
    }
  }
  
  // MARK: - Data Binding
  
  /// 홈 정보로 카드에 표시될 내용을 업데이트합니다.
  public func setData(_ homeInfo: HomeInfo) {
    // 1) 목표/최근 페이스 포맷(기존과 동일)
    if let paceGoal = homeInfo.paceGoal, paceGoal != 0 {
      let sec = Int(paceGoal)
      let m = sec / 60, s = sec % 60
      targetValueLabel.text = "\(m)'\(String(format: "%02d", s))\""
    } else {
      targetValueLabel.text = "-’--”"
    }
    if let recentP = homeInfo.recentPace {
      let sec = Int(recentP)
      let m = sec / 60, s = sec % 60
      recentValueLabel.text = "\(m)'\(String(format: "%02d", s))\""
    } else {
      recentValueLabel.text = "-’--”"
    }

    // 2) 진행도 스택뷰로 그리기
    let total = homeInfo.weeklyRunningCount ?? 0
    let done  = homeInfo.thisWeekRunningCount ?? 0

    // 기존 뷰 모두 제거
    progressStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    // segment 수만큼 추가
    for i in 0..<total {
      let v = UIView()
      v.layer.cornerRadius = 1
      v.backgroundColor = i < done
        ? UIColor(hex: "#FF6600")
        : FRColor.Fg.Nuetral.gray300
      progressStackView.addArrangedSubview(v)
    }
  }
}
