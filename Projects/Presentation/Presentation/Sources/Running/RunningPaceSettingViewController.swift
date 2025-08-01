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
import Lottie

final class RunningPaceSettingViewController: BaseViewController {

  // MARK: - Properties

  weak var coordinator: RunningCoordinator?

  // TODO: - 서버로 부터 값 받도록 수정
  private let challengerPace: Float = 5 * 60
  private let routinePace: Float = 7 * 60
  private let warmUpPace: Float = 9 * 60

  private lazy var paceValues: [Float] = [warmUpPace, routinePace, challengerPace]

  // MARK: - UI Elements

  private let backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }

  private let infoBannerView = UIView().then {
    $0.backgroundColor = FRColor.Fg.Nuetral.gray1000
    $0.layer.cornerRadius = 8
  }

  private let infoBannerLabel = UILabel().then {
    $0.text = "슬라이더로 조절하거나 직접 입력할 수 있어요!"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .white
  }

  private let infoBannerCloseButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = .black
  }

  private let myPaceLabel = UILabel().then {
    $0.text = "나의 페이스는"
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = FRColor.Fg.Text.secondary
  }

  private lazy var paceInputTextField = UITextField().then {
    $0.text = "7'00''"
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 60, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
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
    $0.minimumTrackTintColor = FRColor.Fg.Nuetral.gray1000
    $0.maximumTrackTintColor = FRColor.Fg.Nuetral.gray300
    $0.thumbTintColor = FRColor.Fg.Nuetral.gray1000
  }

  private let warmUpLabel = UILabel().then {
    $0.text = "워밍업"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.tertiary
  }

  private let routineLabel = UILabel().then {
    $0.text = "루틴"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.primary
  }

  private let challengerLabel = UILabel().then {
    $0.text = "챌린저"
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.tertiary
  }

  private let infoBoxView = UIView().then {
    $0.backgroundColor = FRColor.Fg.Nuetral.gray200
    $0.layer.cornerRadius = 10
  }

  private let infoIcon = UIImageView().then {
    $0.image = UIImage(systemName: "questionmark.circle.fill")
    $0.tintColor = FRColor.Fg.Nuetral.gray800
  }

  private let infoTitleLabel = UILabel().then {
    $0.text = "페이스"
    $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.secondary
  }

  private let infoDescriptionLabel = UILabel().then {
    $0.text = "러닝에서 '페이스'는 1km당 걸리는 시간으로,\n나의 러닝 속도를 나타내는 기준이에요.\n처음 달린 기록을 토대로 추천 페이스를 알려주고 있어요."
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.numberOfLines = 0
  }

  private let confirmButton = UIButton().then {
    $0.setTitle("설정하기", for: .normal)
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 10
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
  }

  private let animationView = LottieAnimationView().then {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
    $0.animationSpeed = 1.0
    $0.animation = LottieAnimation.named("toast_completed", bundle: .module)
    $0.isHidden = true
  }

  private var confirmButtonBottomConstraint: Constraint?

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupLayout()
    bind()
    setupKeyboardNotifications()
    setupTapGestureForDismissKeyboard()

    setSliderAndUI(toIndex: 1)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - UI Setup

  private func setupUI() {
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
    view.addSubview(animationView)
  }

  // MARK: - Layout

  private func setupLayout() {
    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(6)
      make.leading.equalToSuperview().offset(6)
      make.width.height.equalTo(44)
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

    warmUpLabel.snp.makeConstraints {
      $0.top.equalTo(fixedPaceSlider.snp.bottom).offset(8)
      $0.centerX.equalTo(fixedPaceSlider.snp.leading)
    }

    routineLabel.snp.makeConstraints {
      $0.top.equalTo(fixedPaceSlider.snp.bottom).offset(8)
      $0.centerX.equalTo(fixedPaceSlider.snp.centerX)
    }

    challengerLabel.snp.makeConstraints {
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

    animationView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(174)
      $0.height.equalTo(208)
    }
  }

  // MARK: - Reactive Binding

  private func bind() {
    backButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.pop()
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

    confirmButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.paceInputTextField.resignFirstResponder()

        object.view.isUserInteractionEnabled = false

        // TODO: - API 연결
        let finalIndex = Int(object.fixedPaceSlider.value.rounded())
        let finalPace = object.paceValues[finalIndex]


        object.animationView.isHidden = false
        object.animationView.play { finished in
          if finished {
            object.animationView.isHidden = true

            object.view.isUserInteractionEnabled = true

            object.coordinator?.pop()
          }
        }
      }
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
    challengerLabel.textColor = (abs(currentPace - challengerPace) < 0.1) ? FRColor.Fg.Text.primary : FRColor.Fg.Text.tertiary
    routineLabel.textColor = (abs(currentPace - routinePace) < 0.1) ? FRColor.Fg.Text.primary : FRColor.Fg.Text.tertiary
    warmUpLabel.textColor = (abs(currentPace - warmUpPace) < 0.1) ? FRColor.Fg.Text.primary : FRColor.Fg.Text.tertiary
  }

  // MARK: - Pace Formatting and Parsing

  private func formatPace(seconds: Float) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%d'%02d''", minutes, remainingSeconds)
  }

  private func parsePace(text: String) -> Float? {
    let cleanedDigits = text.filter(\.isWholeNumber)

    guard cleanedDigits.count >= 3 else { return nil }

    let minutesString = cleanedDigits.count == 4 ? cleanedDigits.prefix(2) : cleanedDigits.prefix(1)
    let minutes = Float(minutesString) ?? 0
    let secondsString = cleanedDigits.suffix(2)
    let seconds = Float(secondsString) ?? 0

    return minutes * 60 + seconds
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

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text else { return false }

    let existingDigits = currentText.filter(\.isNumber)
    let newDigits = string.filter(\.isNumber)

    var updatedDigits = existingDigits

    if string.isEmpty {
      if !updatedDigits.isEmpty {
        updatedDigits.removeLast()
      }
    } else {
      if updatedDigits.count < 4 {
        updatedDigits.append(contentsOf: newDigits)
      }
    }

    let formatted: String
    switch updatedDigits.count {
    case 0:
      formatted = ""
    case 1:
      formatted = "\(updatedDigits)'"
    case 2:
      let sec = updatedDigits.suffix(1)
      formatted = "\(updatedDigits.prefix(1))'\(sec)'"
    case 3:
      let min = updatedDigits.prefix(1)
      let sec = updatedDigits.suffix(2)
      formatted = "\(min)'\(sec)''"

      if let totalSeconds = parsePace(text: formatted) {
        setSliderAndUI(toPace: totalSeconds)
      }
    case 4:
      let min = updatedDigits.prefix(2)
      let sec = updatedDigits.suffix(2)
      formatted = "\(min)'\(sec)''"

      if let totalSeconds = parsePace(text: formatted) {
        setSliderAndUI(toPace: totalSeconds)
      }
    default:
      formatted = ""
    }

    textField.text = formatted
    return false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text, (parsePace(text: text) == nil) else { return }
    showInvalidInputAlert()
    setSliderAndUI(toIndex: 1)
  }
}
