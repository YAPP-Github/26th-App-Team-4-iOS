//
//  FRWalkThroughCollectionCell.swift
//  MaumNote_iOS
//
//  Created by JDeoks on 7/9/25.
//


import UIKit
import ReactorKit
import Then
import SnapKit
import Core

public final class WalkThroughCollectionCell: BaseCollectionViewCell {
  
  public let titleLabel = UILabel().then {
    $0.text = "Welcome to FITRUN"
    $0.font = UIFont.boldSystemFont(ofSize: 28)
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  public let descriptionLabel = UILabel().then {
    $0.text = "Your journey to fitness starts here."
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    $0.textAlignment = .center
    $0.textColor = .gray
    $0.numberOfLines = 0
  }
  
  public let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  public func setData(step: WalkThroughStep) {
    titleLabel.text = step.title
    descriptionLabel.text = step.description
  }
  
  public override func initConstraints() {
    super.initConstraints()

    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(20)
      $0.centerX.equalTo(contentView)
    }
    
    contentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.centerX.equalTo(contentView)
    }
    
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
      $0.centerX.equalTo(contentView)
      $0.width.equalTo(contentView).multipliedBy(0.6)
      $0.height.equalTo(imageView.snp.width) // ✅ 1:1
      $0.bottom.lessThanOrEqualTo(contentView).inset(20)
    }
  }

}
