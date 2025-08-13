//
//  MyPageSelectView.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import Domain

class MyPageSelectView: BaseView {
  
  private lazy var rootVStack = UIStackView(
    arrangedSubviews: [imageLabel, titleLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 10
    $0.alignment = .center
  }
  
  let imageLabel = UILabel().then {
    $0.text = "🐣"
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  let titleLabel = UILabel().then {
    $0.text = "가볍게 달리는 워밍업 러너"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  func setData(image: String, title: String, isSelected: Bool) {
    imageLabel.text = image
    titleLabel.text = title
    updateUI(isSelected: isSelected)
  }
  
  override func initUI() {
    self.backgroundColor = FRColor.Fg.Nuetral.gray0
    self.layer.borderWidth = 2
    self.layer.borderColor = FRColor.Fg.Nuetral.gray400.cgColor
    self.layer.cornerRadius = 12
    
    self.addSubview(rootVStack)
    rootVStack.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  private func updateUI(isSelected: Bool) {
    if isSelected {
      self.layer.borderColor = FRColor.Fg.Border.Interactive.primary.cgColor
      self.backgroundColor = .init(hex: "FFF3EC")
      titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    } else {
      self.layer.borderColor = FRColor.Fg.Nuetral.gray400.cgColor
      self.backgroundColor = FRColor.Fg.Nuetral.gray0
      titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
  }
}
