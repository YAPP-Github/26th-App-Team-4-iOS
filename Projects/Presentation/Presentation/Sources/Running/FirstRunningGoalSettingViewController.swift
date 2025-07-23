//
//  FirstRunningGoalSettingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/21/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Lottie


final class ClearSelectionTextField: UITextField {
  override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
    return []
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
}

final class FirstRunningGoalSettingViewController: UIViewController {

  // MARK: - Properties

  enum GoalInputType {
    case time // 시간 입력 화면
    case distance // 거리 입력 화면

    var title: String {
      switch self {
      case .time:
        return "한 번에 몇 분을 달려볼까요?"
      case .distance:
        return "한 번에 몇 km를 달려볼까요?"
      }
    }

    var subTitle: String {
      switch self {
      case .time:
        return "러닝을 처음 시작할 땐 30분을 목표로\n걷기와 달리기를 번갈아 달려보는 걸 추천해요."
      case .distance:
        return "러닝을 처음 시작할 땐\n3km를 목표로 달리는 걸 추천해요."
      }
    }

    var unit: String {
      switch self {
      case .time:
        return "분"
      case .distance:
        return "km"
      }
    }

    var initialGoalValue: Int {
      switch self {
      case .time:
        return 30
      case .distance:
        return 3
      }
    }
  }

  weak var coordinator: RunningCoordinator?

  private let disposeBag = DisposeBag()
  private var inputType: GoalInputType
  private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0)
  private let currentGoalValue = BehaviorRelay<Int>(value: 0) // 현재 입력된 목표 값 (분 또는 km)

  // MARK: - UI Elements

  let backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    $0.tintColor = .white
  }

  let skipButton = UIButton().then {
    $0.setTitle("건너뛰기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
  }

  let titleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .white
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  let subTitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .lightGray
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  lazy var goalValueTextField = ClearSelectionTextField().then {
    $0.text = "0"
    $0.font = UIFont.systemFont(ofSize: 60, weight: .bold)
    $0.textColor = .white
    $0.tintColor = .clear
    $0.textAlignment = .center
    $0.keyboardType = .numberPad
    $0.isUserInteractionEnabled = true
    $0.delegate = self
  }

  let goalValueUnderline = UIView().then {
    $0.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 0/255, alpha: 1.0)
    $0.isHidden = true
  }

  let unitLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    $0.textColor = UIColor(red: 255/255, green: 112/255, blue: 0/255, alpha: 1.0)
    $0.textAlignment = .left
  }

  let setAndRunButton = UIButton().then {
    $0.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 0/255, alpha: 1.0)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.setTitle("설정하고 달리기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
  }

  let animationView = LottieAnimationView(name: "LottieCheckAnimation.json").then {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
    $0.animationSpeed = 1.0
    $0.isHidden = true
  }

  private var setAndRunButtonBottomConstraint: Constraint?


  // MARK: - Initialization

  init(inputType: GoalInputType) {
    self.inputType = inputType
    super.init(nibName: nil, bundle: nil)
    setupInitialUIForInputType()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialUIForInputType() {
    titleLabel.text = inputType.title
    subTitleLabel.text = inputType.subTitle
    unitLabel.text = inputType.unit
    currentGoalValue.accept(inputType.initialGoalValue)
    goalValueTextField.text = String(currentGoalValue.value)
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    setupLayout()
    bindUI()
    addTargets()
    setupKeyboardHandling()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    goalValueTextField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
    view.endEditing(true)
  }

  // MARK: - Setup Layout

  private func setupLayout() {
    view.addSubview(backButton)
    view.addSubview(skipButton)
    view.addSubview(titleLabel)
    view.addSubview(goalValueTextField)
    view.addSubview(goalValueUnderline)
    view.addSubview(unitLabel)
    view.addSubview(subTitleLabel)
    view.addSubview(setAndRunButton)
    view.addSubview(animationView)

    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
      make.leading.equalToSuperview().offset(20)
      make.width.height.equalTo(30)
    }

    skipButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
      make.trailing.equalToSuperview().offset(-20)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(backButton.snp.bottom).offset(40)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    subTitleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    goalValueTextField.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(subTitleLabel.snp.bottom).offset(60)
      make.width.lessThanOrEqualToSuperview().inset(40)
    }

    goalValueUnderline.snp.makeConstraints { make in
      make.centerX.equalTo(goalValueTextField)
      make.top.equalTo(goalValueTextField.snp.bottom).offset(4)
      make.width.equalTo(goalValueTextField).offset(10)
      make.height.equalTo(2)
    }

    unitLabel.snp.makeConstraints { make in
      make.leading.equalTo(goalValueTextField.snp.trailing).offset(8)
      make.centerY.equalTo(goalValueTextField.snp.centerY).offset(5)
    }

    setAndRunButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(54)
      self.setAndRunButtonBottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(-46).constraint
    }

    animationView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalTo(200)
    }
  }

  // MARK: - Rx Binding

  private func bindUI() {
    goalValueTextField.rx.text
      .orEmpty
      .map { Int($0) ?? 0 }
      .bind(to: currentGoalValue)
      .disposed(by: disposeBag)

    currentGoalValue
      .map { String($0) }
      .bind(to: goalValueTextField.rx.text)
      .disposed(by: disposeBag)

    let tapBackground = UITapGestureRecognizer()
    view.addGestureRecognizer(tapBackground)
    tapBackground.rx.event
      .filter { [weak self] gesture in
        guard let self = self else { return false }
        let location = gesture.location(in: self.view)
        return !self.goalValueTextField.frame.contains(location)
      }
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.view.endEditing(true)
      }
      .disposed(by: disposeBag)

    keyboardHeight
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] height in
        guard let self = self else { return }
        let offset: CGFloat
        if height > 0 {
          offset = -(height + 12)
        } else {
          offset = -46
        }
        self.setAndRunButtonBottomConstraint?.update(offset: offset)

        self.view.layoutIfNeeded()
      })
      .disposed(by: disposeBag)

    setAndRunButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.view.endEditing(true)

        object.view.isUserInteractionEnabled = false

//        object.animationView.isHidden = false
//        object.animationView.play { [weak self] finished in
//          guard let self = self else { return }
//
//          if finished {
//            object.animationView.isHidden = true
//
//            object.view.isUserInteractionEnabled = true
//
//            object.coordinator?.showRunning()
//          }
//        }
        object.coordinator?.showRunning()
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Underline Animation

  private func animateUnderline(isVisible: Bool) {
    if isVisible {
      self.goalValueUnderline.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
      self.goalValueUnderline.isHidden = false
      self.goalValueUnderline.transform = .identity
//      self.view.layoutIfNeeded()
    } else {
      UIView.animate(withDuration: 0.25, animations: {
        self.goalValueUnderline.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
      }) { _ in
        self.goalValueUnderline.isHidden = true
        self.goalValueUnderline.transform = .identity
      }
    }
  }

  // MARK: - Button Actions

  private func addTargets() {
    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
  }

  @objc private func backButtonTapped() {

  }

  @objc private func skipButtonTapped() {

  }

  // MARK: - Keyboard Handling

  private func setupKeyboardHandling() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .map { notification -> CGFloat in
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
      }
      .bind(to: keyboardHeight)
      .disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .map { _ -> CGFloat in 0 }
      .bind(to: keyboardHeight)
      .disposed(by: disposeBag)
  }
}

// MARK: - UITextFieldDelegate

extension FirstRunningGoalSettingViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    animateUnderline(isVisible: true)

    textField.selectAll(nil)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    animateUnderline(isVisible: false)
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.text == "0" && string.isEmpty {
      return false
    }

    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)

    let currentText = textField.text as NSString?
    let newText = currentText?.replacingCharacters(in: range, with: string) ?? ""
    guard allowedCharacters.isSuperset(of: characterSet) else { return false }

    if newText.count > 1 && newText.first == "0"{
      textField.text = String(newText.dropFirst())
      if let value = Int(textField.text ?? "") {
        currentGoalValue.accept(value)
      }
      return false
    }

    let maxLength = 4
    if newText.count > maxLength {
      return false
    }

    return true
  }

}


//import SwiftUI
//
//struct FirstRunningGoalSettingRepresentable: UIViewControllerRepresentable {
//  func makeUIViewController(context: Context) -> FirstRunningGoalSettingViewController {
//    // Instantiate your UIKit ViewController
//    return FirstRunningGoalSettingViewController(inputType: .distance)
//  }
//
//  func updateUIViewController(_ uiViewController: FirstRunningGoalSettingViewController, context: Context) {
//    // No updates needed for this simple preview
//  }
//}
//
//struct FirstRunningGoalSettingViewController_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      FirstRunningGoalSettingRepresentable()
//        .previewDevice("iPhone 15 Pro")
//        .edgesIgnoringSafeArea(.all)
//    }
//  }
//}
