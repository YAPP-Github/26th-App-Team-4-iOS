//
//  PaceCountSettingViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/18/25.
//


import UIKit
import Core
import ReactorKit
import RxKeyboard

public final class PaceCountSettingViewController: BaseViewController {
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let goalSegmentedView = GoalSegmentedView()
  
  private let goalPaceView = GoalPaceView()
  
  private let nextButton = UIButton().then {
    $0.setTitle("루틴 설정하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.backgroundColor = UIColor(hex: "#FF6600")
    $0.layer.cornerRadius = 16
  }
  
  public override func initUI() {
    super.initUI()
    
    self.view.backgroundColor = .white
    
    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(24)
    }
    
    view.addSubview(goalSegmentedView)
    goalSegmentedView.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    view.addSubview(goalPaceView)
    goalPaceView.snp.makeConstraints {
      $0.top.equalTo(goalSegmentedView.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(56)
    }
  }
  
  public override func action() {
    super.action()
    
    RxKeyboard.instance.visibleHeight
      .skip(1)
      .drive(with: self) { object, height in
        let safeAreaBottomInset = object.view.safeAreaInsets.bottom
        if height > 0 {
          object.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(object.view.safeAreaLayoutGuide).inset(height + 12 - safeAreaBottomInset)
          }
        } else {
          object.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(object.view.safeAreaLayoutGuide).inset(12)
          }
        }
        object.view.layoutIfNeeded()
      }
      .disposed(by: self.disposeBag)
  }
}
