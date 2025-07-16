//
//  BaseViewController.swift
//  Core
//
//  Created by JDeoks on 7/12/25.
//


import UIKit

import RxSwift

import SnapKit
import Then

open class BaseViewController: UIViewController {
  
  public var disposeBag = DisposeBag()
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    action()
  }
  
  /// 레이아웃, 뷰 초기값 설정
  open func initUI() {
    self.view.backgroundColor = .white
  }
  
  /// 사용자 인터렉션을 처리
  /// - 리액터와 관련 없는 인터렉션만 처리
  open func action() { }
}
