//
//  OnboardingSectionHeaderView.swift
//  Presentation
//
//  Created by JDeoks on 7/12/25.
//

import UIKit
import SnapKit
import Then

public final class OnboardingSectionHeaderView: UITableViewHeaderFooterView {
  public static let identifier = "OnboardingSectionHeaderView"

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textColor = .black
    $0.numberOfLines = 0
  }

  public override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .white
    contentView.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().inset(8)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Call in viewForHeaderInSection
  public func configure(title: String) {
    titleLabel.text = title
  }
}
