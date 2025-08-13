//
//  DeleteAccountTableCell.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public class DeleteAccountTableCell: BaseTableViewCell {
  
  private lazy var rootHStack = UIStackView(
    arrangedSubviews: [radioImageView, titleLabel, requireLabel, UIView(), showTermsButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.alignment = .center
  }
  
  private let radioImageView = UIImageView().then {
    $0.image = UIImage(named: "RadioOff", in: Bundle.module, compatibleWith: nil)
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .medium)
    $0.textColor = FRColor.Fg.Text.secondary
    $0.text = "회원탈퇴 약관 동의"
  }
  
  private let requireLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .medium)
    $0.textColor = FRColor.Fg.Text.warningBold
    $0.text = "*"
  }
  
  let showTermsButton = UIButton().then {
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.setTitle("약관 보기", for: .normal)
    $0.setTitleColor(FRColor.Fg.Text.Interactive.secondary, for: .normal)
  }
  
  func setData(text: String, isChecked: Bool, showTerms: Bool) {
    titleLabel.text = text
    radioImageView.image = UIImage(named: isChecked ? "RadioOn" : "RadioOff", in: Bundle.module, compatibleWith: nil)
    requireLabel.isHidden = !showTerms
    showTermsButton.isHidden = !showTerms
  }
  
  public override func initUI() {
    super.initUI()

    contentView.backgroundColor = .clear
    contentView.addSubview(rootHStack)
    rootHStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-8)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(40)
    }
    
    radioImageView.snp.makeConstraints {
      $0.size.equalTo(18)
    }
  }
}
