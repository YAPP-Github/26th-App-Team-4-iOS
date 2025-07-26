//
//  RecordDetailLapTableFooterView.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public class RecordDetailLapTableFooterView: BaseView {
  private let footerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
  
  public override func initUI() {
    super.initUI()
    self.addSubview(footerView)
    footerView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(48)
    }
  }
}
