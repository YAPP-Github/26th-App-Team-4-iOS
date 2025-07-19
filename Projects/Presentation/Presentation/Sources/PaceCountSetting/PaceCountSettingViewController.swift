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

public final class PaceCountSettingViewController: BaseViewController, View {
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let goalSegmentedView = GoalSegmentedView()
  
  private let goalRunningCountView = GoalRunningCountView().then {
    $0.isHidden = true
  }
  private let goalPaceView = GoalPaceView()
  
  private let nextButton = UIButton().then {
    $0.setTitle("루틴 설정하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.backgroundColor = UIColor(hex: "#FF6600")
    $0.layer.cornerRadius = 16
  }
  
  private let goalSaveAlertView = GoalSaveAlertView().then {
    $0.isHidden = true
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
  
  public func bind(reactor: PaceCountSettingReactor) {
    
    self.rx.viewDidLoad
      .map { Reactor.Action.initialize }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    nextButton.rx.tap
      .withUnretained(self)
      .bind { owner, _ in
        let segment = owner.goalSegmentedView.selectedSegment.value
        switch segment {
        case .pace:
          let seconds = owner.goalPaceView.selectedPaceSeconds
          reactor.action.onNext(.savePace(paceSecond: seconds))
        case .runningCount:
          let count = owner.goalRunningCountView.currentCount
          reactor.action.onNext(.saveRunningCount(runningCount: count))
        }
      }
      .disposed(by: disposeBag)
    
    // 페이스 값 구독 → GoalPaceView 업데이트
    reactor.state
      .map(\.paceSecond)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] seconds in
        self?.goalPaceView.setPace(seconds: seconds)
      })
      .disposed(by: disposeBag)

    // 러닝 카운트 값 구독 → GoalRunningCountView 업데이트
    reactor.state
      .map(\.runningCount)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] count in
        self?.goalRunningCountView.setCount(count)
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isSaved)
      .observe(on: MainScheduler.instance)
      .filter { $0 }
      .subscribe(with: self) { owner, _ in
        owner.showGoalSaveAlert()
      }
      .disposed(by: disposeBag)
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
        object.switchGoalView(to: index)
      }
      .disposed(by: disposeBag)
  }
  
  private func switchGoalView(to index: GoalSegmentedView.Segment) {
    let showPaceView = (index == .pace)
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
