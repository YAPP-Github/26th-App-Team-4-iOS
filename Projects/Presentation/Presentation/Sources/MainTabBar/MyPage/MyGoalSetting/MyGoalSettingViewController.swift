//
//  MyGoalSettingViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/15/25.
//

import UIKit
import Core
import ReactorKit
import RxKeyboard

public final class MyGoalSettingViewController: BaseViewController {
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let goalSegmentedView = MyGoalSegmentView()
  
  private let goalRunningCountView = GoalRunningTimeView().then {
    $0.isHidden = true
  }
  
  private let goalPaceView = GoalRunningTimeView()
  
  private let nextButton = UIButton().then {
    $0.setTitle("설정하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.backgroundColor = UIColor(hex: "#FF6600")
    $0.layer.cornerRadius = 16
  }
  
  private let goalSaveAlertView = GoalSaveAlertView().then {
    $0.isHidden = true
  }
  
  public override init() {
    super.init()
    self.hidesBottomBarWhenPushed = true
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    view.addSubview(goalRunningCountView)
    goalRunningCountView.snp.makeConstraints {
      $0.top.equalTo(goalSegmentedView.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }

    view.addSubview(goalPaceView)
    goalPaceView.snp.makeConstraints {
      $0.edges.equalTo(goalRunningCountView)
    }
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(56)
    }
    
    view.addSubview(goalSaveAlertView)
    goalSaveAlertView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public override func action() {
    super.action()
    
    backButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
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
    
    goalSegmentedView.selectedSegment
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(with: self) { object, index in
        object.view.endEditing(true)
        object.switchGoalView(to: index)
      }
      .disposed(by: disposeBag)
  }
  
private func switchGoalView(to index: MyGoalSegmentView.Segment) {
  let showPaceView = (index == .goalTime)
    let toHideView = showPaceView ? goalRunningCountView : goalPaceView
    let toShowView = showPaceView ? goalPaceView : goalRunningCountView

    UIView.animate(withDuration: 0.15, animations: {
      toHideView.alpha = 0
    }, completion: { _ in
      toHideView.isHidden = true
      toShowView.alpha = 0
      toShowView.isHidden = false
      UIView.animate(withDuration: 0.15) {
        toShowView.alpha = 1
      }
    })
  }
  
  private func showGoalSaveAlert() {
    print(self, #function)
    
    goalSaveAlertView.isHidden = false
    goalSaveAlertView.alpha = 0

    UIView.animate(
      withDuration: 0.3,
      animations: {
        self.goalSaveAlertView.alpha = 1
      },
      completion: { _ in
        UIView.animate(
          withDuration: 0.3,
          delay: 0.3,
          animations: {
            self.goalSaveAlertView.alpha = 0
          },
          completion: { _ in
            self.goalSaveAlertView.isHidden = true
          }
        )
      }
    )
  }
}
