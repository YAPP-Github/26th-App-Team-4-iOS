//
//  FirstRunningPopUpView.swift
//  Presentation
//
//  Created by dong eun shin on 7/30/25.
//

import UIKit
import SnapKit
import Then
import Core

final class FirstRunningPopUpView: UIView {

  private let dimmedBackgroundView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
  }

  private let popupCardView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }

  private let confettiImageView = UIImageView().then {
    $0.image = UIImage(named: "sparkles", in: .module, with: nil)
    $0.contentMode = .scaleAspectFit
  }

  private let titleLabel = UILabel().then {
    $0.text = "첫 러닝\n완주 축하해요!"
    $0.font = UIFont.boldSystemFont(ofSize: 24)
    $0.textColor = FRColor.Fg.Text.primary
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }

  private let descriptionLabel = UILabel().then {
    $0.text = "체력분석과 최초 러닝 기록으로\n나에게 딱 맞는 페이스를 확인해보세요."
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = FRColor.Fg.Text.secondary
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }

  private let confirmButton = UIButton().then {
    $0.setTitle("추천 페이스 확인하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = FRColor.Bg.Interactive.primary
    $0.layer.cornerRadius = 16
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
  }

  private let closeButton = UIButton().then {
    $0.setImage(UIImage(named: "close", in: .module, with: nil), for: .normal)
    $0.imageView?.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
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
    addSubview(dimmedBackgroundView)
    dimmedBackgroundView.addSubview(popupCardView)

    popupCardView.addSubview(confettiImageView)
    popupCardView.addSubview(titleLabel)
    popupCardView.addSubview(descriptionLabel)
    popupCardView.addSubview(confirmButton)
    popupCardView.addSubview(closeButton)

    confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
  }

  private func setupConstraints() {
    dimmedBackgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview() // Fills the entire PopUpView
    }

    popupCardView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(290)
      make.height.equalTo(360)
    }

    closeButton.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(20)
      make.right.equalToSuperview().inset(15)
      make.width.height.equalTo(24)
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
      make.height.equalTo(56)
      make.bottom.equalToSuperview().offset(-30)
    }
  }

  // MARK: - Action Handlers

  @objc private func confirmButtonTapped() {
    onConfirm?()
    self.removeFromSuperview()
  }

  @objc private func closeButtonTapped() {
    self.removeFromSuperview()
  }

  func show(in view: UIView) {
    self.frame = view.bounds
    view.addSubview(self)

    self.alpha = 0
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
  }

  func dismiss() {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0
    }) { _ in
      self.removeFromSuperview()
    }
  }
}
