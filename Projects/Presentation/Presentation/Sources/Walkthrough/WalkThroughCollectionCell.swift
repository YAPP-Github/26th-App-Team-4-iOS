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

public class WalkThroughCollectionCell: BaseCollectionViewCell {
  
  private let titleLabel = UILabel().then {
    $0.text = "Welcome to FITRUN"
    $0.font = UIFont.boldSystemFont(ofSize: 28)
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let descriptionLabel = UILabel().then {
    $0.text = "Your journey to fitness starts here."
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    $0.textAlignment = .center
    $0.textColor = .gray
    $0.numberOfLines = 0
  }
  
  public let imageView = UIView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  public func setData(step: WalkThroughStep) {
    titleLabel.text = step.title
    descriptionLabel.text = step.description
  }
  
  public override func initConstraints() {
    super.initConstraints()

//    print("titleLabel", titleLabel, "descriptionLabel", descriptionLabel)
    // 아 이거 왜 titleLabel nil인거지 미치겠다....
    // 1) 스택뷰 생성
    let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, imageView]).then {
      $0.axis = .vertical
      $0.spacing = 16
      $0.alignment = .fill      // 레이블은 full-width, 이미지뷰는 아래 제약으로 크기 지정
      $0.distribution = .fill
    }
    
    // 2) 스택뷰 추가 및 여백 제약
    contentView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }
    
//    // 3) imageView에만 가로폭·종횡비 제약 추가
//    imageView.snp.makeConstraints { make in
//      make.size.equalTo(200)
//    }
  }
}
