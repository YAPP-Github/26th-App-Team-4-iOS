//
//  MyPageMenuTableHeaderView.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public class MyPageMenuTableHeaderView: BaseView {
  
  private let titleLabel = UILabel().then {
    $0.text = "러닝 목표"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.secondary
  }

  private let radiusView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  init(title: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func initUI() {
    super.initUI()
    
    self.addSubview(radiusView)
    radiusView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(16)
    }
    
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.height.equalTo(20)
      $0.bottom.equalTo(radiusView.snp.top).offset(-12)
    }
  }
}
