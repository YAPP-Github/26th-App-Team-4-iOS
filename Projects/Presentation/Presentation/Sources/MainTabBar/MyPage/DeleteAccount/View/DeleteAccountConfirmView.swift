//
//  DeleteAccountConfirmView.swift
//  Presentation
//
//  Created by JDeoks on 8/16/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import Core

public final class DeleteAccountConfirmView: BaseView {

  // MARK: - Public callbacks / options
  public var onCancel: (() -> Void)?
  public var onConfirm: (() -> Void)?
  /// 딤뷰 탭 시 닫기
  public var dismissOnDimTap: Bool = true

  // MARK: - UI
  private let dimView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.45)
    $0.alpha = 1
  }

  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.layer.masksToBounds = true
  }
  
  private let iconView = UIImageView().then {
    $0.image = UIImage(systemName: "exclamationmark.triangle.fill")
    $0.tintColor = UIColor(hex: "#FFB300")
    $0.contentMode = .scaleAspectFit
    $0.setContentHuggingPriority(.required, for: .vertical)
  }

  private let titleLabel = UILabel().then {
    $0.text = "회원 탈퇴 전 꼭 확인해주세요!"
    $0.font = .systemFont(ofSize: 18, weight: .heavy)
    $0.textColor = UIColor(hex: "#1A1C20")
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }

  private let messageLabel = UILabel().then {
    $0.text = "탈퇴 시 러닝 기록, 목표 설정, 크루 정보 등\n모든 데이터가 삭제되며,\n재가입하셔도 복구되지 않습니다."
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.textColor = UIColor(hex: "#868B94")
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }

  private let highlightLabel = UILabel().then {
    $0.text = "탈퇴를 진행할까요?"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = UIColor(hex: "#FF3B30")
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }

  private let buttonsStack = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 12
    $0.distribution = .fillEqually
    $0.layoutMargins = UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  public private(set) var cancelButton = UIButton(type: .system).then {
    $0.setTitle("취소", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.setTitleColor(UIColor(hex: "#1A1C20"), for: .normal)
    $0.backgroundColor = UIColor(hex: "#FFFFFF")
    $0.layer.cornerRadius = 14
    $0.layer.borderColor = UIColor(hex: "#E4E6EA").cgColor
    $0.layer.borderWidth = 1
  }

  public private(set) var confirmButton = UIButton(type: .system).then {
    $0.setTitle("탈퇴하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = UIColor(hex: "#1A1C20")
    $0.layer.cornerRadius = 14
  }

  // MARK: - Layout
  public override func initUI() {
    backgroundColor = .clear

    // dim
    addSubview(dimView)
    dimView.snp.makeConstraints { $0.edges.equalToSuperview() }

    // container: 흰 배경을 화면 맨 아래까지
    addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview() // ← 세이프에어리어 무시하고 화면 끝까지
    }

    // 콘텐츠 스택
    let contentStack = UIStackView(arrangedSubviews: [
      iconView, titleLabel, messageLabel, highlightLabel, buttonsStack
    ]).then {
      $0.axis = .vertical
      $0.alignment = .fill
      $0.spacing = 16
      $0.isLayoutMarginsRelativeArrangement = true
      $0.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 20, right: 20)
    }

    containerView.addSubview(contentStack)
    contentStack.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.lessThanOrEqualToSuperview() // ← 하단은 여유만 둠(버튼 제약이 실제 하단을 책임짐)
    }

    iconView.snp.makeConstraints { $0.height.equalTo(60) }

    buttonsStack.addArrangedSubview(cancelButton)
    buttonsStack.addArrangedSubview(confirmButton)
    cancelButton.snp.makeConstraints { $0.height.equalTo(56) }
    confirmButton.snp.makeConstraints { $0.height.equalTo(56) }

    // ✅ 버튼만 세이프에어리어 위로
    buttonsStack.snp.makeConstraints {
      $0.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(20)
    }
  }


  public override func action() {
    super.action()

    // dim tap
    dimView.rx.tapGesture()
      .when(.recognized)
      .bind(with: self) { owner, _ in
        owner.onCancel?()
      }
      .disposed(by: disposeBag)

    cancelButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.onCancel?()
      }
      .disposed(by: disposeBag)

    confirmButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.onConfirm?()
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Public modifiers

  /// 텍스트 커스터마이즈
  public func configure(title: String? = nil, message: String? = nil, highlight: String? = nil) {
    if let t = title { titleLabel.text = t }
    if let m = message { messageLabel.text = m }
    if let h = highlight { highlightLabel.text = h }
  }

  /// 상단 둥근 모서리만 / 전체 둥근 모서리
  public func setCornerStyle(topOnly: Bool) {
    containerView.layer.maskedCorners = topOnly
      ? [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      : [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}
