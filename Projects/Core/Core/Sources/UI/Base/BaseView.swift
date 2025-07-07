//
//  BaseView.swift
//  Core
//
//  Created by JDeoks on 7/7/25.
//


import UIKit
import RxSwift

class BaseView: UIView {
  
  var disposeBag = DisposeBag()
  
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    initUI()
    action()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - initUI
  func initUI() {
    self.backgroundColor = .clear
  }
  
  // MARK: - action
  func action() { }
}