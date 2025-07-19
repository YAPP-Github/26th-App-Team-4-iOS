//
//  BaseView.swift
//  Core
//
//  Created by JDeoks on 7/18/25.
//


import UIKit
import RxSwift

open class BaseView: UIView {
  
  public var disposeBag = DisposeBag()

  // MARK: - init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initUI()
    action()
  }
  
  public convenience init() {
    self.init(frame: .zero)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - initUI
  open func initUI() {
    self.backgroundColor = .clear
  }
  
  // MARK: - action
  open func action() { }
}
