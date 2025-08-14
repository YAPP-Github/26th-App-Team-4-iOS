//
//  CustomAlertView.swift
//  Presentation
//
//  Created by dong eun shin on 8/15/25.
//

import UIKit
import SnapKit
import Core

protocol CustomAlertViewDelegate: AnyObject {
  func deleteButtonTapped()
}

class CustomAlertView: UIView {
  weak var delegate: CustomAlertViewDelegate?

  private let dimmedView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
  }

  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }

  private let messageLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14)
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.textColor = .gray
  }

  private let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 7
  }

  private let cancelButton = UIButton().then {
    $0.setTitle("닫기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.setTitleColor(FRColor.Fg.Text.Interactive.inverse, for: .normal)
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.layer.cornerRadius = 12
  }

  private let deleteButton = UIButton().then {
    $0.setTitle("삭제하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.setTitleColor(FRColor.Fg.Text.Interactive.primary, for: .normal)
    $0.backgroundColor = FRColor.Bg.Interactive.selected
    $0.layer.cornerRadius = 12
  }

  init(title: String, message: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    self.messageLabel.text = message
    setupUI()
    setupActions()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    self.addSubview(dimmedView)
    dimmedView.snp.makeConstraints { $0.edges.equalToSuperview() }

    self.addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.equalTo(172)
      $0.width.equalTo(286)
    }

    containerView.addSubview(titleLabel)
    containerView.addSubview(messageLabel)
    containerView.addSubview(buttonStackView)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    messageLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalTo(titleLabel)
    }

    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(44)
      $0.width.equalTo(238)
    }

    buttonStackView.addArrangedSubview(cancelButton)
    buttonStackView.addArrangedSubview(deleteButton)
  }

  private func setupActions() {
    cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
  }

  @objc private func cancelButtonTapped() {
    self.removeFromSuperview()
  }

  @objc private func deleteButtonTapped() {
    delegate?.deleteButtonTapped()
    self.removeFromSuperview()
  }
}
