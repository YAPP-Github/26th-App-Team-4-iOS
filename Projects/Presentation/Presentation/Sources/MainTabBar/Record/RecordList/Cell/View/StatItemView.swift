//
//  StatItemView.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public class StatItemView: BaseView {
  
  private lazy var stack = UIStackView(arrangedSubviews: [
    titleLabel, valueStack
  ]).then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.spacing = 4
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "평균 페이스"
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = FRColor.FG.Text.tertiary
  }
  
  private lazy var valueStack = UIStackView(arrangedSubviews: [
    valueLabel, unitLabel
  ]).then {
    $0.axis = .horizontal
    $0.alignment = .bottom
    $0.spacing = 2
  }
  
  private let valueLabel = UILabel().then {
    $0.text = "7'18"
    $0.font = .systemFont(ofSize: 20, weight: .semibold)
    $0.textColor = .black
  }
  
  private let unitLabel = UILabel().then {
    $0.text = "회"
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = FRColor.FG.Text.primary
  }
  public override func initUI() {
    super.initUI()
    
    self.addSubview(stack)
    stack.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    valueStack.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    unitLabel.snp.makeConstraints {
      $0.width.equalTo(20)
    }
  }
}
