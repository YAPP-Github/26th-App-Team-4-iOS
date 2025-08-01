//
//  FRWalkThroughCollectionCell.swift
//  Presentation
//
//  Created by JDeoks on 7/9/25.
//

import UIKit
import Then
import SnapKit
import Core

public final class WalkThroughCollectionCell: UICollectionViewCell {

  // MARK: - UI Components
  private let titleLabel = UILabel().then {
    $0.text = "Welcome to FITRUN"
    $0.font = UIFont.boldSystemFont(ofSize: 28)
    $0.textAlignment = .center
    $0.textColor = FRColor.Fg.Text.primary
  }

  private let descriptionLabel = UILabel().then {
    $0.text = "Your journey to fitness starts here."
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    $0.textAlignment = .center
    $0.textColor = FRColor.Fg.Text.secondary
    $0.numberOfLines = 0
  }

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup
  private func setupViews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(imageView)
  }

  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.centerX.equalToSuperview()
    }

    imageView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalTo(imageView.snp.width) // 1:1 비율
      $0.bottom.lessThanOrEqualToSuperview().inset(20)
    }
  }

  // MARK: - Public
  public func setData(step: WalkThroughStep) {
    titleLabel.text = step.title
    descriptionLabel.text = step.description
  }
}
