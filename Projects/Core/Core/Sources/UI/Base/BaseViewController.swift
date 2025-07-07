//
//  BaseViewController.swift
//  Core
//
//  Created by JDeoks on 7/7/25.
//


import UIKit

import RxKeyboard
import RxSwift

import SnapKit
import Then

class BaseViewController: UIViewController {
  
  var disposeBag = DisposeBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initUI()
    action()
    registerKeyboard()
  }
  
  /// 레이아웃, 뷰 초기값 설정
  func initUI() {
    self.view.backgroundColor = .white
  }
  
  /// 사용자 인터렉션을 처리
  /// - 리액터와 관련 없는 인터렉션만 처리
  func action() { }
  
  private func registerKeyboard() {
    RxKeyboard.instance.visibleHeight
      .skip(1)
      .drive(with: self) { object, height in
        let connectedScene: UIScene? = UIApplication.shared.connectedScenes.first
        let sceneDelegate: SceneDelegate? = connectedScene?.delegate as? SceneDelegate
        let safeAreaInsetBottom: CGFloat = sceneDelegate?.window?.safeAreaInsets.bottom ?? 0
        let withoutBottomSafeInset: CGFloat = max(0, height - safeAreaInsetBottom)
        object.keyboardUpdated(heightFromSafeArea: withoutBottomSafeInset, height: height)
      }
      .disposed(by: self.disposeBag)
  }
  
  /// 키보드 높이 변경 시 호출되는 콜백 메서드
  ///
  /// - Parameters:
  ///   - heightFromSafeArea: Safe Area Bottom 기준 키보드의 높이.
  ///     (ex. 입력창이나 버튼 등 SafeArea 안에 위치한 요소의 위치 조정을 위한 값)
  ///   - height: ViewController의 뷰 하단 기준 키보드의 전체 높이.
  ///     (Safe Area를 포함한 절대적 높이, 뷰 전체 기준 마진 계산 등에 사용)
  func keyboardUpdated(heightFromSafeArea: CGFloat, height: CGFloat) { }
}
