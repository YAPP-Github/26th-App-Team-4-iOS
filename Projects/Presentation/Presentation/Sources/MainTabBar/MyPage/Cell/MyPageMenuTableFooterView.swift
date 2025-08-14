//
//  MyPageMenuTableFooterView.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core

public class MyPageMenuTableFooterView: BaseView {
  private let footerView = UIView().then {
    $0.backgroundColor = FRColor.Bg.primary
    $0.layer.cornerRadius = 16
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
  
  public override func initUI() {
    super.initUI()
    self.addSubview(footerView)
    footerView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
  }
}
