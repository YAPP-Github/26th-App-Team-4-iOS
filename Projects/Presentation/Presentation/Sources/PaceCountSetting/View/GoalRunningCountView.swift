//
//  GoalRunningCountView.swift
//  Presentation
//
//  Created by JDeoks on 7/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Core

public final class GoalRunningCountView: BaseView {
  
  // MARK: - UI Components

  private let weekLabel = UILabel().then {
    $0.text = "일주일에"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = UIColor(hex: "#555D6D")
    $0.textAlignment = .center
  }
  
  private lazy var countLabelStack = UIStackView(
    arrangedSubviews: [countLabel, countDescLabel]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 0
    $0.alignment = .center
  }

  private let countLabel = UILabel().then {
    $0.text = "3"
    $0.font = .systemFont(ofSize: 52, weight: .bold)
    $0.textColor = UIColor(hex: "#1A1C20")
    $0.textAlignment = .center
  }
  
  private let countDescLabel = UILabel().then {
    $0.text = "회"
    $0.font = .systemFont(ofSize: 32, weight: .semibold)
    $0.textColor = UIColor(hex: "#868B94")
    $0.textAlignment = .center
  }
  
  private let hiddenTextField = UITextField().then {
    $0.keyboardType = .numberPad
    $0.textColor = .clear
    $0.tintColor = .clear
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.autocapitalizationType = .none
    $0.isHidden = true
  }

  private let underlineView = UIView().then {
    $0.backgroundColor = UIColor(hex: "#FF6600")
    $0.layer.cornerRadius = 1
    $0.isHidden = true
  }

  private let reminderBox = UIView().then {
    $0.backgroundColor = UIColor(hex: "#F7F8FA")
    $0.layer.cornerRadius = 16
  }

  private let reminderTitleLabel = UILabel().then {
    $0.text = "리마인드 알림"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = UIColor(hex: "#1C1C1E")
  }

  private let reminderDescriptionLabel = UILabel().then {
    $0.text = "오전 10시에 리마인드 알림을 보내드려요"
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = UIColor(hex: "#868B94")
  }

  private let reminderToggle = UISwitch().then {
    $0.onTintColor = UIColor(hex: "#2A3038")
  }

  private lazy var reminderLabelStack = UIStackView(arrangedSubviews: [
    reminderTitleLabel, reminderDescriptionLabel
  ]).then {
    $0.axis = .vertical
    $0.spacing = 4
  }

  // MARK: - Layout

  public override func initUI() {
    
    addSubview(weekLabel)
    weekLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
    }

    addSubview(countLabelStack)
    countLabelStack.snp.makeConstraints {
      $0.top.equalTo(weekLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }
    
    addSubview(hiddenTextField)
    hiddenTextField.snp.makeConstraints {
      $0.edges.equalTo(countLabel)
    }

    addSubview(underlineView)
    underlineView.snp.makeConstraints {
      $0.top.equalTo(countLabelStack.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(countLabel).inset(-2)
      $0.height.equalTo(2)
    }

    addSubview(reminderBox)
    reminderBox.snp.makeConstraints {
      $0.top.equalTo(underlineView.snp.bottom).offset(40)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(88)
    }
    
    reminderBox.addSubview(reminderLabelStack)
    reminderLabelStack.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
    reminderBox.addSubview(reminderToggle)
    reminderToggle.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  public override func action() {
    super.action()

    // 라벨 탭 시 텍스트필드 포커싱 및 초기화
    countLabel.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        self?.beginEditingCount()
        self?.underlineView.isHidden = false
      }
      .disposed(by: disposeBag)

    // 텍스트 입력 시 라벨 업데이트
    hiddenTextField.rx.text.orEmpty
      .observe(on: MainScheduler.asyncInstance)
      .distinctUntilChanged()
      .bind { [weak self] text in
        self?.updateCountLabelSafely(with: text)
      }
      .disposed(by: disposeBag)
  }
  
  private func updateCountLabelSafely(with raw: String) {
    if raw.isEmpty {
      countLabel.text = "3"
      return
    }
    let digits = raw.filter { $0.isNumber }
    guard digits != countLabel.text else { return } // ✅ 재진입 방지

    if digits.count >= 1 {
      let trimmed = String(digits.prefix(1))
      hiddenTextField.text = trimmed
      countLabel.text = trimmed
      hiddenTextField.resignFirstResponder()
    } else {
      countLabel.text = digits
    }
  }

  private func beginEditingCount() {
    hiddenTextField.text = ""
    countLabel.text = "0"
    hiddenTextField.becomeFirstResponder()
  }
}
