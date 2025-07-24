//
//  RunningPaceSettingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/21/25.
//

import UIKit
import Core
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RunningPaceSettingViewController: BaseViewController {
  
  // MARK: - Properties
  
  weak var coordinator: RunningCoordinator?
  
  private let challengerPace: Float = 10 * 60
  private let routinePace: Float = 7 * 60
  private let warmUpPace: Float = 5 * 60
  
  private lazy var paceValues: [Float] = [challengerPace, routinePace, warmUpPace]
  
  // MARK: - UI Elements
  
  private let backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let infoBannerView = UIView().then {
    $0.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // Light grey
    $0.layer.cornerRadius = 8
  }
  
  private let infoBannerLabel = UILabel().then {
    $0.text = "슬라이더로 조절하거나 직접 입력할 수 있어요!"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .black
  }
  
  private let infoBannerCloseButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = .black
  }
  
  private let myPaceLabel = UILabel().then {
    $0.text = "나의 페이스는"
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = .black
  }
  
  private lazy var paceInputTextField = UITextField().then {
    $0.text = "7'00''"
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 60, weight: .bold)
    $0.textColor = .black
    $0.keyboardType = .numberPad
    $0.borderStyle = .none
    $0.tintColor = .clear
    $0.delegate = self
  }
  
  private let fixedPaceSlider = UISlider().then {
    $0.minimumValue = 0
    $0.maximumValue = 2
    $0.value = 1
    $0.isContinuous = true
    $0.minimumTrackTintColor = .orange
    $0.maximumTrackTintColor = .lightGray
    $0.thumbTintColor = .orange
  }
  
  private let warmUpLabel = UILabel().then {
    $0.text = "워밍업"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .gray
  }
  
  private let routineLabel = UILabel().then {
    $0.text = "루틴"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .black
  }
  
  private let challengerLabel = UILabel().then {
    $0.text = "챌린저"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .gray
  }
  
  private let infoBoxView = UIView().then {
    $0.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
  }
  
  private let infoIcon = UIImageView().then {
    $0.image = UIImage(systemName: "questionmark.circle.fill")
    $0.tintColor = .darkGray
  }
  
  private let infoTitleLabel = UILabel().then {
    $0.text = "페이스"
    $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    $0.textColor = .black
  }
  
  private let infoDescriptionLabel = UILabel().then {
    $0.text = "러닝에서 '페이스'는 1km당 걸리는 시간으로,\n나의 러닝 속도를 나타내는 기준이에요.\n처음 달린 기록을 토대로 추천 페이스를 알려주고 있어요."
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .darkGray
    $0.numberOfLines = 0
  }
  
  private let confirmButton = UIButton().then {
    $0.setTitle("설정하기", for: .normal)
    $0.backgroundColor = .orange
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 10
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
  }
  
  private var confirmButtonBottomConstraint: Constraint?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupLayout()
    bindViewModel()
    setupKeyboardNotifications()
    setupTapGestureForDismissKeyboard()
    
    setSliderAndUI(toIndex: 1)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - UI Setup
  
  private func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(backButton)
    view.addSubview(infoBannerView)
    infoBannerView.addSubview(infoBannerLabel)
    infoBannerView.addSubview(infoBannerCloseButton)
    view.addSubview(myPaceLabel)
    view.addSubview(paceInputTextField)
    view.addSubview(fixedPaceSlider)
    view.addSubview(warmUpLabel)
    view.addSubview(routineLabel)
    view.addSubview(challengerLabel)
    view.addSubview(infoBoxView)
    infoBoxView.addSubview(infoIcon)
    infoBoxView.addSubview(infoTitleLabel)
    infoBoxView.addSubview(infoDescriptionLabel)
    view.addSubview(confirmButton)
  }
  
  // MARK: - Layout
  
  private func setupLayout() {
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(20)
      $0.width.height.equalTo(30)
    }
    
    infoBannerView.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(44)
    }
    
    infoBannerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
    
    infoBannerCloseButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    myPaceLabel.snp.makeConstraints {
      $0.top.equalTo(infoBannerView.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
    }
    
    paceInputTextField.snp.makeConstraints {
      $0.top.equalTo(myPaceLabel.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(250)
      $0.height.equalTo(80)
    }
    
    fixedPaceSlider.snp.makeConstraints {
      $0.top.equalTo(paceInputTextField.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(30)
    }
    
    challengerLabel.snp.makeConstraints {
      $0.top.equalTo(fixedPaceSlider.snp.bottom).offset(8)
      $0.centerX.equalTo(fixedPaceSlider.snp.leading)
    }
    
    routineLabel.snp.makeConstraints {
      $0.top.equalTo(fixedPaceSlider.snp.bottom).offset(8)
      $0.centerX.equalTo(fixedPaceSlider.snp.centerX)
    }
    
    warmUpLabel.snp.makeConstraints {
      $0.top.equalTo(fixedPaceSlider.snp.bottom).offset(8)
      $0.centerX.equalTo(fixedPaceSlider.snp.trailing)
    }
    
    infoBoxView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.greaterThanOrEqualTo(120)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-104)
    }
    
    infoIcon.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(20)
    }
    
    infoTitleLabel.snp.makeConstraints {
      $0.top.equalTo(infoIcon.snp.top)
      $0.leading.equalTo(infoIcon.snp.trailing).offset(8)
    }
    
    infoDescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(infoTitleLabel.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalToSuperview().inset(16)
    }
    
    confirmButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      self.confirmButtonBottomConstraint = $0.bottom.equalTo(view.snp.bottom).offset(-46).constraint
      $0.height.equalTo(50)
    }
  }
  
  // MARK: - Reactive Binding (RxSwift/RxCocoa)
  
  private func bindViewModel() {
    backButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    infoBannerCloseButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.infoBannerView.isHidden = true
      })
      .disposed(by: disposeBag)
    
    fixedPaceSlider.rx.value
      .skip(1)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] rawValue in
        guard let self = self else { return }
        
        let snappedIndex = Int(rawValue.rounded())
        
        if abs(self.fixedPaceSlider.value - Float(snappedIndex)) > 0.01 {
          UIView.animate(withDuration: 0.1) {
            self.fixedPaceSlider.value = Float(snappedIndex)
          }
        }
        
        self.setSliderAndUI(toIndex: snappedIndex)
      })
      .disposed(by: disposeBag)
    
    paceInputTextField.rx.text
      .orEmpty
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if !self.paceInputTextField.isFirstResponder {
          if let totalSeconds = self.parsePace(text: text) {
            self.setSliderAndUI(toPace: totalSeconds)
          }
        }
      })
      .disposed(by: disposeBag)
    
    confirmButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.paceInputTextField.resignFirstResponder()
        
        guard let self = self else { return }
        let finalIndex = Int(self.fixedPaceSlider.value.rounded())
        let finalPace = self.paceValues[finalIndex]
        // TODO: - 서버 전달
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Slider Index & UI Sync Helpers
  
  private func closestIndex(for pace: Float) -> Int {
    var closestIndex = 0
    var minDifference = Float.greatestFiniteMagnitude
    
    for (index, targetPace) in paceValues.enumerated() {
      let difference = abs(pace - targetPace)
      if difference < minDifference {
        minDifference = difference
        closestIndex = index
      }
    }
    return closestIndex
  }
  
  private func setSliderAndUI(toIndex index: Int) {
    let clampedIndex = max(0, min(paceValues.count - 1, index))
    fixedPaceSlider.value = Float(clampedIndex)
    let currentPace = paceValues[clampedIndex]
    paceInputTextField.text = formatPace(seconds: currentPace)
    updatePaceLabelsTextColor(for: currentPace)
  }
  
  private func setSliderAndUI(toPace paceInSeconds: Float) {
    let index = closestIndex(for: paceInSeconds)
    setSliderAndUI(toIndex: index)
  }
  
  // MARK: - UI Update for Pace Labels
  private func updatePaceLabelsTextColor(for currentPace: Float) {
    challengerLabel.textColor = (abs(currentPace - challengerPace) < 0.1) ? .black : .gray
    routineLabel.textColor = (abs(currentPace - routinePace) < 0.1) ? .black : .gray
    warmUpLabel.textColor = (abs(currentPace - warmUpPace) < 0.1) ? .black : .gray
  }
  
  // MARK: - Pace Formatting and Parsing
  
  private func formatPace(seconds: Float) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%d'%02d''", minutes, remainingSeconds)
  }
  
  private func parsePace(text: String) -> Float? {
    let cleanedText = text.filter { $0.isNumber }
    
    guard cleanedText.count >= 1 else { return nil }
    
    if cleanedText.count == 4 {
      if let minutes = Float(cleanedText.prefix(2)),
         let seconds = Float(cleanedText.suffix(2)) {
        if seconds < 60 {
          return minutes * 60 + seconds
        }
      }
    } else if cleanedText.count <= 2 {
      if let minutes = Float(cleanedText) {
        return minutes * 60
      }
    } else if cleanedText.count == 3 {
      if let minutes = Float(cleanedText.prefix(1)),
         let seconds = Float(cleanedText.suffix(2)) {
        if seconds < 60 {
          return minutes * 60 + seconds
        }
      }
    }
    
    let components = text.replacingOccurrences(of: "''", with: "").components(separatedBy: "'")
    if components.count == 2,
       let minutes = Float(components[0]),
       let seconds = Float(components[1]) {
      if seconds < 60 {
        return minutes * 60 + seconds
      }
    } else if components.count == 1, let minutes = Float(components[0]) {
      return minutes * 60
    }
    
    return nil
  }
  
  private func showInvalidInputAlert() {
    let alert = UIAlertController(title: "오류", message: "올바른 페이스 형식을 입력해주세요", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Keyboard Handling for Confirm Button
  
  private func setupKeyboardNotifications() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .subscribe(onNext: { [weak self] notification in
        self?.handleKeyboard(notification: notification, willShow: true)
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .subscribe(onNext: { [weak self] notification in
        self?.handleKeyboard(notification: notification, willShow: false)
      })
      .disposed(by: disposeBag)
  }
  
  private func handleKeyboard(notification: Notification, willShow: Bool) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
          let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
    
    let keyboardHeight = keyboardFrame.height
    let bottomInset = willShow ? -(keyboardHeight + 12) : -46
    
    UIView.animate(withDuration: animationDuration) {
      self.confirmButtonBottomConstraint?.update(offset: bottomInset)
      self.view.layoutIfNeeded()
    }
  }
  
  // MARK: - Dismiss Keyboard on Tap Outside
  
  private func setupTapGestureForDismissKeyboard() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}

// MARK: - UITextFieldDelegate

extension RunningPaceSettingViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let currentPaceText = textField.text ?? ""
    let cleanedText = currentPaceText.filter { $0.isNumber }
    textField.text = cleanedText
    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text else { return true }
    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
    let filteredText = newText.filter { $0.isNumber }
    return filteredText.count <= 4
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text, let totalSeconds = parsePace(text: text) {
      setSliderAndUI(toPace: totalSeconds)
    } else {
      showInvalidInputAlert()
      let currentIndex = Int(fixedPaceSlider.value.rounded())
      setSliderAndUI(toIndex: currentIndex)
    }
  }
}
