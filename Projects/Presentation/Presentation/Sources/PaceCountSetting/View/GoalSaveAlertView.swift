//
//  GoalSaveAlertView.swift
//  Presentation
//
//  Created by JDeoks on 7/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Core

public class GoalSaveAlertView: BaseView {

  private lazy var containerStackView: UIStackView = {
    // 1) Blur + 반투명 검정 배경
    let blurEffect = UIBlurEffect(style: .systemMaterialDark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.backgroundColor = UIColor(white: 0, alpha: 0.8)
    blurView.layer.cornerRadius = 12
    blurView.clipsToBounds = true

    // 2) Content stack
    let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
    stack.axis = .vertical
    stack.spacing = 16
    stack.alignment = .center
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 56, left: 0, bottom: 56, right: 0)
    stack.layer.cornerRadius = 12

    // 3) BlurView를 stack 밑에 삽입
    stack.insertSubview(blurView, at: 0)
    blurView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    return stack
  }()
  private let titleLabel = UILabel().then {
    $0.text = "목표 설정 완료"
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.textColor = .white
    $0.textAlignment = .center
  }
  
  private let imageView = UIImageView().then {
    $0.image = UIImage(named: "area", in: Bundle.module, compatibleWith: nil)
  }
  
  public override func initUI() {
    super.initUI()
    
    backgroundColor = .clear
    
    addSubview(containerStackView)
    containerStackView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(175)
    }
    
    imageView.snp.makeConstraints {
      $0.size.equalTo(60)
    }
    
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
  }
}
