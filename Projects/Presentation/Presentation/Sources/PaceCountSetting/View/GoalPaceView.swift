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

  // MARK: - Properties

  /// 슬라이더의 스텝 인덱스
  private let steps: [Float] = [0, 1, 2]
  /// 각 스텝에 대응하는 페이스(초)
  private let stepValues: [Int] = [9 * 60, 7 * 60 + 30, 5 * 60 + 30]

  /// 외부에서 읽어 쓸 수 있는 선택된 페이스(초)
  public private(set) var selectedPaceSeconds: Int = 7 * 60 + 30

  /// 현재 화면에 표시 중인 페이스 문자열
  public private(set) var currentPace: String = "7'30\"" {
    didSet { paceLabel.text = currentPace }
  }

  /// 스텝별 표시할 페이스 텍스트
  private let paceOptions = ["9'00\"", "7'30\"", "5'30\""]

  // MARK: - UI Components

  private let weekLabel = UILabel().then {
    $0.text = "일주일에"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = UIColor(hex: "#555D6D")
    $0.textAlignment = .center
  }

  private lazy var paceLabel = UILabel().then {
    $0.text = currentPace
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

  private lazy var slider = UISlider().then {
    $0.tintColor = .black
    $0.minimumValue = steps.first!
    $0.maximumValue = steps.last!
    $0.value = 1
    $0.isContinuous = true
  }

  private lazy var difficultyStack = UIStackView(
    arrangedSubviews: [warmupLabel, routineLabel, challengerLabel]
  ).then {
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

  // MARK: - Layout

  public override func initUI() {
    addSubview(weekLabel)
    weekLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
    }

    addSubview(paceLabel)
    paceLabel.snp.makeConstraints {
      $0.top.equalTo(weekLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
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

    // 초기 스텝 반영
    updateUIForStep(Int(slider.value))
  }

  // MARK: - Bindings

  public override func action() {
    super.action()

    // 1) 라벨 탭 → 수동 입력 모드
    paceLabel.rx.tapGesture()
      .when(.recognized)
      .bind { [weak self] _ in self?.handleLabelTapped() }
      .disposed(by: disposeBag)

    // 2) 텍스트 입력 → 포맷 후 selectedPaceSeconds 업데이트
    hiddenTextField.rx.text.orEmpty
      .distinctUntilChanged()
      .bind { [weak self] in self?.handleTextChanged($0) }
      .disposed(by: disposeBag)

    // 3) 슬라이더 터치 종료 시 → 가장 가까운 스텝으로 스냅
    Observable.merge(
      slider.rx.controlEvent(.touchUpInside).asObservable(),
      slider.rx.controlEvent(.touchUpOutside).asObservable()
    )
    .withLatestFrom(slider.rx.value)
    .subscribe(onNext: { [weak self] value in
      guard let self = self else { return }
      let nearest = self.steps.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
      self.slider.setValue(nearest, animated: true)
      self.updateUIForStep(Int(nearest))
    })
    .disposed(by: disposeBag)
  }

  // MARK: - Helpers

  private func updateUIForStep(_ step: Int) {
    // 1) 텍스트와 내부 초 단위 값 동시 갱신
    currentPace = paceOptions[step]
    selectedPaceSeconds = stepValues[step]
    // 2) 하단 탭 라벨 색상 변경
    [warmupLabel, routineLabel, challengerLabel]
      .enumerated()
      .forEach { i, lbl in
        lbl.textColor = (i == step)
          ? .black
          : UIColor(hex: "#868B94")
      }
  }

  private func handleLabelTapped() {
    hiddenTextField.text = ""
    paceLabel.text = "0'00\""
    hiddenTextField.becomeFirstResponder()
    paceLabelBottomLineView.isHidden = false
  }

  private func handleTextChanged(_ raw: String) {
    let digits = raw.filter { $0.isNumber }
    guard !digits.isEmpty else {
      paceLabel.text = "0'00\""
      return
    }

    if digits.count >= 3 {
      // "MSS" 형태 → 초 단위 변환
      let padded = digits.paddingRight(toLength: 3, withPad: "0")
      let minutes = Int(padded.prefix(1)) ?? 0
      let seconds = Int(padded.suffix(2)) ?? 0
      let total = minutes * 60 + seconds

      selectedPaceSeconds = total
      currentPace = formatPaceInput(padded)

      hiddenTextField.resignFirstResponder()
      paceLabelBottomLineView.isHidden = true
    } else {
      paceLabel.text = formatPaceInput(digits)
    }
  }

  private func formatPaceInput(_ raw: String) -> String {
    let digits = raw.filter { $0.isNumber }
    let padded = digits.paddingRight(toLength: 3, withPad: "0")
    let minutes = String(padded.prefix(1))
    let seconds = String(padded.suffix(2))
    return "\(minutes)'\(seconds)\""
  }
}

public extension GoalPaceView {
  /// 외부에서 초 단위 페이스를 받아서 슬라이더와 라벨 동기화
  func setPace(seconds: Int) {
    // 1) 미리 정의된 stepValues에 해당하는 값이면 스냅
    if let idx = stepValues.firstIndex(of: seconds) {
      slider.setValue(steps[idx], animated: false)
      updateUIForStep(idx)
    } else {
      // 2) 수동 입력 페이스로 처리
      selectedPaceSeconds = seconds
      // 분/초 문자열 포맷
      let m = seconds / 60
      let s = seconds % 60
      currentPace = "\(m)'\(String(format: "%02d", s))\""
    }
  }
}

// MARK: - String Padding Extension

private extension String {
  func paddingRight(toLength: Int, withPad character: Character) -> String {
    let padCount = max(0, toLength - count)
    return self + String(repeating: character, count: padCount)
  }
}
