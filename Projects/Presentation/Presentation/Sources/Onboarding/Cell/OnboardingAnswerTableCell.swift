//
//  OnboardingAnswerTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/12/25.
//

import UIKit
import SnapKit
import Then

import Core


public final class OnboardingAnswerTableCell: BaseTableViewCell {

  public override var isSelected: Bool {
    didSet {
      let borderColor = isSelected
        ? UIColor.systemOrange.cgColor
        : UIColor.systemGray4.cgColor
      containerView.layer.borderColor = borderColor
      checkmarkView.isHidden = !isSelected
    }
  }
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 2
    $0.layer.borderColor = UIColor.systemGray4.cgColor
    $0.clipsToBounds = true
  }

  private let iconView = UILabel().then {
    $0.font = .systemFont(ofSize: 24, weight: .bold)
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
    $0.textColor = .label
  }

  private let checkmarkView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(systemName: "checkmark.circle.fill")
    $0.tintColor = .systemOrange
    $0.isHidden = true
  }

  public override func initUI() {
    super.initUI()
    contentView.backgroundColor = .white
    contentView.addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().inset(8)
      $0.height.greaterThanOrEqualTo(76)
    }
    
    containerView.addSubview(iconView)
    iconView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
    
    containerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(iconView.snp.trailing).offset(12)
      $0.centerY.equalToSuperview()
    }
    
    containerView.addSubview(checkmarkView)
    checkmarkView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    // Reset cell state
    titleLabel.text = nil
    iconView.text = nil
    isSelected = false
  }

  /// Configure cell with icon, title, and selected state
  public func setData(iconText: String, title: String, selected: Bool) {
    titleLabel.text = title
    isSelected = selected
    iconView.text = iconText
  }
  
  public func setIsSelected(isSelected: Bool) {
    self.isSelected = isSelected
  }
}
