//
//  GoalRunningTimeView.swift
//  Presentation
//
//  Created by JDeoks on 8/15/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Core

public final class GoalRunningTimeView: BaseView {

  public private(set) var currentCount: Int = 3 {
    didSet { countLabel.text = "\(currentCount)" }
  }

  private let weekLabel = UILabel().then {
    $0.text = "한 번 달릴 때"
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

  private lazy var countLabel = UILabel().then {
    $0.text = "\(currentCount)"
    $0.font = .systemFont(ofSize: 52, weight: .bold)
    $0.textColor = UIColor(hex: "#1A1C20")
    $0.textAlignment = .center
    $0.isUserInteractionEnabled = true
  }

  private let countDescLabel = UILabel().then {
    $0.text = "분"
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
  
  init(unit: String = "분") {
    super.init(frame: .zero)
    countDescLabel.text = unit
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle

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
  }

  public func setCount(_ count: Int) {
    currentCount = count
  }

  public override func action() {
    super.action()

    // 라벨 탭 → 편집 시작 (기존 값으로 시작)
    countLabel.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in
        self?.beginEditingCount()
        self?.underlineView.isHidden = false
      }
      .disposed(by: disposeBag)

    // 입력 중: 자리수 제한 없이 모든 숫자 반영
    hiddenTextField.rx.text.orEmpty
      .observe(on: MainScheduler.asyncInstance)
      .distinctUntilChanged()
      .bind { [weak self] text in
        self?.updateCountLabelSafely(with: text)
      }
      .disposed(by: disposeBag)

    // 편집 종료 시 언더라인 숨김
    hiddenTextField.rx.controlEvent(.editingDidEnd)
      .bind { [weak self] in
        self?.underlineView.isHidden = true
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Editing

  private func beginEditingCount() {
    hiddenTextField.text = "\(currentCount)"   // 기존 값 이어서 편집
    underlineView.isHidden = false
    hiddenTextField.becomeFirstResponder()
    moveCaretToEnd(hiddenTextField)
  }

  private func updateCountLabelSafely(with raw: String) {
    let digits = raw.filter { $0.isNumber }

    // 아무 숫자도 없으면 0 표시 (state도 0)
    guard !digits.isEmpty else {
      currentCount = 0
      countLabel.text = "0"
      return
    }

    // 선행 0 제거 후 Int 변환 (자리 제한 없음)
    let noLeadingZero = String(digits.drop { $0 == "0" })
    let normalized = noLeadingZero.isEmpty ? "0" : noLeadingZero

    if let value = Int(normalized) {
      currentCount = value
      countLabel.text = "\(value)"
      // 편집감 유지를 위해 hiddenTextField.text는 변경하지 않음
    }
    // Int 범위 초과 등은 무시 (원하면 클램핑 추가)
  }

  private func moveCaretToEnd(_ textField: UITextField) {
    DispatchQueue.main.async {
      let end = textField.endOfDocument
      textField.selectedTextRange = textField.textRange(from: end, to: end)
    }
  }
}
