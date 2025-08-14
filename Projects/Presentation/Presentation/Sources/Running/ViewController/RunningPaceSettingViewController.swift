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
import ReactorKit

final class RunningPaceSettingViewController: BaseViewController, View {
  typealias Reactor = RunningPaceSettingReactor
  
  // MARK: - Properties
  
  weak var coordinator: PaceSettingCoordinator?
  private var toastHideDisposable: Disposable?
  
  // MARK: - UI Elements
  
  private let backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let toastView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.7)
    $0.layer.cornerRadius = 8
    $0.alpha = 0.0
  }
  
  private let toastIconImageView = UIImageView().then {
    $0.image = UIImage(systemName: "exclamationmark.circle.fill")
    $0.tintColor = FRColor.Fg.Icon.Interactive.primary
  }
  
  private let toastLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .white
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
  
  private let underlineView = UIView().then {
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.isHidden = true
  }
  
  private let fixedPaceSlider = UISlider().then {
    $0.minimumValue = 0
    $0.maximumValue = 2
    $0.value = 1
    $0.isContinuous = false
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
    $0.tintColor = .white
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
    setupKeyboardNotifications()
    setupTapGestureForDismissKeyboard()
    
    reactor?.action.onNext(.viewDidLoad)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    toastHideDisposable?.dispose()
  }
  
  // MARK: - UI Setup
  
  private func setupUI() {
    view.addSubview(backButton)
    view.addSubview(myPaceLabel)
    view.addSubview(paceInputTextField)
    view.addSubview(underlineView)
    view.addSubview(fixedPaceSlider)
    view.addSubview(warmUpLabel)
    view.addSubview(routineLabel)
    view.addSubview(challengerLabel)
    view.addSubview(infoBannerView)
    infoBannerView.addSubview(infoBannerLabel)
    infoBannerView.addSubview(infoBannerCloseButton)
    view.addSubview(infoBoxView)
    infoBoxView.addSubview(infoIcon)
    infoBoxView.addSubview(infoTitleLabel)
    infoBoxView.addSubview(infoDescriptionLabel)
    view.addSubview(toastView)
    toastView.addSubview(toastIconImageView)
    toastView.addSubview(toastLabel)
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
    
    toastView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(72)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(48)
    }
    
    toastIconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    toastLabel.snp.makeConstraints {
      $0.leading.equalTo(toastIconImageView.snp.trailing).offset(8)
      $0.centerY.equalToSuperview()
      $0.trailing.lessThanOrEqualToSuperview().offset(-16)
    }
    
    myPaceLabel.snp.makeConstraints {
      $0.top.equalTo(infoBannerView.snp.bottom).offset(18)
      $0.centerX.equalToSuperview()
    }
    
    paceInputTextField.snp.makeConstraints {
      $0.top.equalTo(myPaceLabel.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(250)
      $0.height.equalTo(80)
    }
    
    underlineView.snp.makeConstraints {
      $0.centerX.equalTo(paceInputTextField)
      $0.top.equalTo(paceInputTextField.snp.bottom)
      $0.width.equalTo(200)
      $0.height.equalTo(2)
    }
    
    fixedPaceSlider.snp.makeConstraints {
      $0.top.equalTo(paceInputTextField.snp.bottom).offset(40)
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
    
    infoBannerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(112)
      $0.leading.trailing.equalToSuperview().inset(42.5)
      $0.height.equalTo(34)
    }
    
    infoBannerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(12)
      $0.centerY.equalToSuperview()
    }
    
    infoBannerCloseButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-8)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(18)
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
  
  func bind(reactor: RunningPaceSettingReactor) {
    // MARK: Action
    backButton.rx.tap
      .map { Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    infoBannerCloseButton.rx.tap
      .map { Reactor.Action.closeInfoBanner }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    fixedPaceSlider.rx.controlEvent(.valueChanged)
      .map { Int(round(self.fixedPaceSlider.value)) }
      .distinctUntilChanged()
      .map { Reactor.Action.sliderValueDidChange($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    paceInputTextField.rx.controlEvent(.editingDidBegin)
      .map { Reactor.Action.paceInputDidBeginEditing }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    paceInputTextField.rx.controlEvent(.editingDidEnd)
      .compactMap { [weak self] _ in self?.paceInputTextField.text }
      .map { Reactor.Action.paceInputDidEndEditing($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    confirmButton.rx.tap
      .map { Reactor.Action.confirmButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // MARK: State
    reactor.state.compactMap { $0.currentPace }
      .distinctUntilChanged()
      .bind { [weak self] pace in
        self?.paceInputTextField.text = self?.formatPace(seconds: pace)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.currentPaceIndex }
      .distinctUntilChanged()
      .bind(onNext: { [weak self] index in
        self?.fixedPaceSlider.setValue(Float(index), animated: true)
        self?.updatePaceLabelsTextColor(forIndex: index)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.toastMessage }
      .distinctUntilChanged()
      .bind(onNext: { [weak self] message in
        self?.showToast(with: message)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map { !$0.isInfoBannerVisible }
      .distinctUntilChanged()
      .bind(to: infoBannerView.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .map { !$0 }
      .bind(to: view.rx.isUserInteractionEnabled)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.shouldAnimateUnderline }
      .distinctUntilChanged()
      .bind(onNext: { [weak self] isVisible in
        self?.animateUnderline(isVisible: isVisible)
      })
      .disposed(by: disposeBag)
    
    reactor.state.compactMap { $0.isSaveSuccess }
      .distinctUntilChanged()
      .filter { $0 }
      .bind(onNext: { [weak self] _ in
        self?.paceInputTextField.resignFirstResponder()
        self?.animationView.isHidden = false
        self?.animationView.play(completion: { _ in
          self?.reactor?.action.onNext(.didFinishAnimation)
        })
      })
      .disposed(by: disposeBag)

    reactor.state.compactMap { $0.navigationTarget }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] target in
        guard let self = self else { return }
        switch target {
        case .finish:
          self.coordinator?.finish()
        case .pop:
          self.coordinator?.pop()
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - UI Helpers
  
  private func showToast(with message: String?) {
    guard let message = message else {
      hideToast()
      return
    }
    
    toastHideDisposable?.dispose()
    self.toastLabel.text = message
    
    let showAnimation = {
      UIView.animate(withDuration: 0.2) {
        self.toastView.alpha = 1.0
      }
    }
    
    let hideAnimation = {
      UIView.animate(withDuration: 0.2) {
        self.toastView.alpha = 0.0
      }
    }
    
    if self.toastView.alpha > 0.0 {
      showAnimation()
    } else {
      showAnimation()
    }
    
    toastHideDisposable = Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance)
      .take(1)
      .subscribe(onNext: { _ in
        hideAnimation()
      })
  }
  
  private func hideToast() {
    toastHideDisposable?.dispose()
    if toastView.alpha > 0.0 {
      UIView.animate(withDuration: 0.2) {
        self.toastView.alpha = 0.0
      }
    }
  }
  
  private func updatePaceLabelsTextColor(forIndex index: Int) {
    warmUpLabel.textColor = (index == 0) ? FRColor.Fg.Text.primary : FRColor.Fg.Text.tertiary
    routineLabel.textColor = (index == 1) ? FRColor.Fg.Text.primary : FRColor.Fg.Text.tertiary
    challengerLabel.textColor = (index == 2) ? FRColor.Fg.Text.primary : FRColor.Fg.Text.tertiary
  }
  
  private func formatPace(seconds: Float) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%d'%02d''", minutes, remainingSeconds)
  }
  
  private func animateUnderline(isVisible: Bool) {
    if isVisible {
      self.underlineView.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
      self.underlineView.isHidden = false
      UIView.animate(withDuration: 0.25) {
        self.underlineView.transform = .identity
      }
    } else {
      UIView.animate(withDuration: 0.25, animations: {
        self.underlineView.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
      }) { _ in
        self.underlineView.isHidden = true
        self.underlineView.transform = .identity
      }
    }
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

extension RunningPaceSettingViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text else { return false }
    
    let existingDigits = currentText.filter(\.isWholeNumber)
    let newDigits = string.filter(\.isWholeNumber)
    
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
      formatted = "\(updatedDigits.prefix(1))'\(sec)''"
    case 3:
      let min = updatedDigits.prefix(1)
      let sec = updatedDigits.suffix(2)
      formatted = "\(min)'\(sec)''"
    case 4:
      let min = updatedDigits.prefix(2)
      let sec = updatedDigits.suffix(2)
      formatted = "\(min)'\(sec)''"
    default:
      formatted = ""
    }
    
    textField.text = formatted
    return false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text, (reactor?.parsePace(text: text) != nil) else {
      showInvalidInputAlert()
      reactor?.action.onNext(.sliderValueDidChange(1))
      return
    }
    reactor?.action.onNext(.paceInputDidEndEditing(text))
  }
  
  private func showInvalidInputAlert() {
    let alert = UIAlertController(title: "오류", message: "올바른 페이스 형식을 입력해주세요", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
