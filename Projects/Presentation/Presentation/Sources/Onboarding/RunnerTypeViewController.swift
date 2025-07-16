//
//  RunnerTypeViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/15/25.
//


import UIKit
import RxSwift
import Then
import SnapKit

import Core

public final class RunnerTypeViewController: BaseViewController {
  
  public var runnerType: String = "워밍업"
  
  private let typeTitleLabel = UILabel().then {
    $0.text = "체력 분석완료\n나는 워밍업 러너에 가까워요"
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .black
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let typeDescriptionLabel = UILabel().then {
    $0.text = "이제 딱 맞는 러닝 목표를 추천해 드릴게요!\n지금 목표 설정을 완료하고 가볍게 시작해볼까요?"
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .gray
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let imageView = UIImageView().then {
    $0.image = UIImage(named: "RunnerType", in: Bundle.module, compatibleWith: nil)
    $0.contentMode = .scaleAspectFit
  }
  
  private let goToHomeButton = UIButton().then {
    $0.setTitle("홈으로", for: .normal)
    $0.tintColor = .white
    $0.backgroundColor = FRColor.BG.interactive.primary
    $0.layer.cornerRadius = 16
  }
  
  public override func initUI() {
    super.initUI()
    
    view.addSubview(typeTitleLabel)
    typeTitleLabel.text = "체력 분석완료\n나는 \(runnerType) 러너에 가까워요"
    typeTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(72)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(typeDescriptionLabel)
    typeDescriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(typeTitleLabel.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalTo(typeDescriptionLabel.snp.bottom).offset(32)
      make.centerX.equalToSuperview()
      make.size.equalTo(230) // Adjust size as needed
    }
    
    view.addSubview(goToHomeButton)
    goToHomeButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(56)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
    }
  }
}
