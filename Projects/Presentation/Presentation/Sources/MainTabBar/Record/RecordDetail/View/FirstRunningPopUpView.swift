//
//  FirstRunningPopUpView.swift
//  Presentation
//
//  Created by dong eun shin on 7/30/25.
//

import UIKit
import SnapKit
import Then

final class FirstRunningPopUpView: UIView {

  private let dimmedBackgroundView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
  }

  private let popupCardView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 15
    $0.clipsToBounds = true
  }

  private let confettiImageView = UIImageView().then {
    $0.image = UIImage(named: "sparkles", in: .module, with: nil)
    $0.contentMode = .scaleAspectFit
  }

  private let titleLabel = UILabel().then {
    $0.text = "첫 러닝\n완주 축하해요!"
    $0.font = UIFont.boldSystemFont(ofSize: 22)
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }

  private let descriptionLabel = UILabel().then {
    $0.text = "체력분석과 최초 러닝 기록으로\n나에게 딱 맞는 페이스를 확인해보세요."
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .gray
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }

  private let confirmButton = UIButton().then {
    $0.setTitle("추천 페이스 확인하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = UIColor(red: 247/255, green: 121/255, blue: 50/255, alpha: 1.0) // Orange color
    $0.layer.cornerRadius = 10
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
  }

  private let closeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    $0.tintColor = .lightGray
  }

  // MARK: - Callbacks for actions
  var onConfirm: (() -> Void)?

  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    // Add a tap gesture to dismiss when tapping outside the card
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmedBackgroundTap))
    dimmedBackgroundView.addGestureRecognizer(tapGesture)

    addSubview(dimmedBackgroundView) // Add to the PopUpView itself
    dimmedBackgroundView.addSubview(popupCardView) // Card view is on top of dimming

    popupCardView.addSubview(confettiImageView)
    popupCardView.addSubview(titleLabel)
    popupCardView.addSubview(descriptionLabel)
    popupCardView.addSubview(confirmButton)
    popupCardView.addSubview(closeButton)

    // Add targets for the buttons
    confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
  }

  private func setupConstraints() {
    dimmedBackgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview() // Fills the entire PopUpView
    }

    popupCardView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(350)
    }

    closeButton.snp.makeConstraints { make in
      make.top.right.equalToSuperview().inset(10)
      make.width.height.equalTo(30)
    }

    confettiImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(80)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(confettiImageView.snp.bottom).offset(15)
      make.left.right.equalToSuperview().inset(20)
    }

    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview().inset(20)
    }

    confirmButton.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
      make.left.right.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.bottom.equalToSuperview().offset(-30)
    }
  }

  // MARK: - Action Handlers (Internal)
  @objc private func handleDimmedBackgroundTap() {
    // Call the external closure if set
    // Or simply remove from superview
    self.removeFromSuperview()
  }

  @objc private func confirmButtonTapped() {
    print("추천 페이스 확인하기 button tapped!")
    // Call the external closure if set
    onConfirm?()
    self.removeFromSuperview() // Dismiss after action
  }

  @objc private func closeButtonTapped() {
    print("Close button tapped!")
    self.removeFromSuperview() // Dismiss
  }

  // MARK: - Public method to show the pop-up
  func show(in view: UIView) {
    self.frame = view.bounds // Match the parent view's bounds
    view.addSubview(self)

    // Optional: Add animation for appearance
    self.alpha = 0
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
  }

  // Public method to dismiss the pop-up
  func dismiss() {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0
    }) { _ in
      self.removeFromSuperview()
    }
  }
}
