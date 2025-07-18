//
//  GoalPaceView.swift
//  Presentation
//
//  Created by JDeoks on 7/19/25.
//



import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

import Core

public final class GoalPaceView: BaseView {
  
  private let weekLabel = UILabel().then {
    $0.text = "일주일에"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = UIColor(hex: "#555D6D")
  }
  
  private let paceLabel = UILabel().then {
    $0.text = "0'00\""
    $0.font = .systemFont(ofSize: 52, weight: .bold)
    $0.textColor = .black
    $0.textAlignment = .center
    $0.isUserInteractionEnabled = true
  }
  
  private let paceLabelBottomLineView = UIView().then {
    $0.backgroundColor = UIColor(hex: "#FF6600")
    $0.isHidden = true
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

  private let slider = UISlider().then {
    $0.tintColor = .black
    $0.minimumValue = 0
    $0.maximumValue = 2
    $0.value = 1
    $0.isContinuous = false
  }

  private lazy var difficultyStack = UIStackView(
    arrangedSubviews: [warmupLabel, routineLabel, challengerLabel]).then {
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
  }

  private let warmupLabel = UILabel().then {
    $0.text = "워밍업"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = UIColor(hex: "#868B94")
  }

  private let routineLabel = UILabel().then {
    $0.text = "루틴"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = UIColor(hex: "#868B94")
  }

  private let challengerLabel = UILabel().then {
    $0.text = "챌린저"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = UIColor(hex: "#868B94")
  }
  
  public override func initUI() {
    
    addSubview(weekLabel)
    weekLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(24)
    }

    addSubview(paceLabel)
    paceLabel.snp.makeConstraints {
      $0.top.equalTo(weekLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(68)
    }
    
    addSubview(paceLabelBottomLineView)
    paceLabelBottomLineView.snp.makeConstraints {
      $0.bottom.equalTo(paceLabel.snp.bottom)
      $0.leading.trailing.equalTo(paceLabel).inset(-4)
      $0.height.equalTo(2)
    }

    addSubview(hiddenTextField)
    hiddenTextField.snp.makeConstraints {
      $0.edges.equalTo(paceLabel)
    }
    
    addSubview(slider)
    slider.snp.makeConstraints {
      $0.top.equalTo(paceLabel.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview()
    }
    
    addSubview(difficultyStack)
    difficultyStack.snp.makeConstraints {
      $0.top.equalTo(slider.snp.bottom).offset(12)
      $0.leading.trailing.equalTo(slider)
    }
  }

  public override func action() {
    super.action()

    // 탭 시 키보드 호출 및 초기화
    paceLabel.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        self?.handleLabelTapped()
      }
      .disposed(by: disposeBag)

    // 텍스트 입력 처리
    hiddenTextField.rx.text.orEmpty
      .distinctUntilChanged()
      .bind { [weak self] text in
        self?.handleTextChanged(text)
      }
      .disposed(by: disposeBag)
  }
  
  private func handleLabelTapped() {
    hiddenTextField.text = ""
    paceLabel.text = "0'00\""
    hiddenTextField.becomeFirstResponder()
    paceLabelBottomLineView.isHidden = false
  }

  private func handleTextChanged(_ raw: String) {
    let digits = raw.filter { $0.isNumber }

    if digits.count >= 3 {
      let trimmed = String(digits.prefix(3))
      hiddenTextField.text = trimmed
      paceLabel.text = formatPaceInput(trimmed)
      hiddenTextField.resignFirstResponder()
      paceLabelBottomLineView.isHidden = true
    } else {
      paceLabel.text = formatPaceInput(digits)
    }
  }

  private func formatPaceInput(_ raw: String) -> String {
    let digits = raw.filter { $0.isNumber }
    guard !digits.isEmpty else { return "0'00\"" }

    let padded = digits.paddingRight(toLength: 3, withPad: "0")
    let minutes = String(padded.prefix(1))
    let seconds = String(padded.suffix(2))

    return "\(minutes)'\(seconds)\""
  }
}
