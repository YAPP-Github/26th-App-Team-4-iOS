//
//  RecordDetailTitleTableCell.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//


import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public class RecordDetailTitleTableCell: BaseTableViewCell {
  
  private lazy var rootStack = UIStackView(
    arrangedSubviews: [titleStack, editButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .top
    $0.layoutMargins = UIEdgeInsets(top: 36, left: 20, bottom: 28, right: 20)
    $0.isLayoutMarginsRelativeArrangement = true
  }
  
  private lazy var titleStack = UIStackView(
    arrangedSubviews: [titleLabel, dateLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .leading
  }
  
  private let titleLabel = UILabel().then { // 32
    $0.text = "7월 20일 점심 러닝"
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .black
    $0.numberOfLines = 1
  }
  
  private let dateLabel = UILabel().then {  // 24
    $0.text = "2025/07/20 13:00:00"
    $0.font = .systemFont(ofSize: 16)
    $0.textColor = FRColor.Fg.Text.secondary.withAlphaComponent(0.8)
  }
    
  let editButton = UIButton(type: .system).then { // 24
    let img = UIImage(named: "EditIcon", in: Bundle.module, compatibleWith: nil)
    $0.setImage(img, for: .normal)
    $0.tintColor = FRColor.Fg.Text.secondary.withAlphaComponent(0.8)
  }
  
  public func setData(
    title: String,
    date: Date
  ) {
    titleLabel.text = title
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    dateLabel.text = dateFormatter.string(from: date)
  }
  
  public override func initUI() {
    super.initUI()
    
    contentView.backgroundColor = .clear

    contentView.addSubview(rootStack)
    rootStack.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(32)
    }
    
    dateLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    editButton.snp.makeConstraints {
      $0.size.equalTo(24)
    }
  }
}
