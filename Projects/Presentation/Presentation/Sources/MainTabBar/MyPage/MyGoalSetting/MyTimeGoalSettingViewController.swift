//
//  MyTimeGoalSettingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 9/15/25.
//

import UIKit
import Core
import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard

public final class MyTimeGoalSettingViewController: BaseViewController, View {

  public typealias Reactor = MyGoalSettingReactor

  var coordinator: MyPageCoordinator?

  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }

  private let goalTimeView = GoalRunningTimeView()

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

    view.backgroundColor = .white

    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(24)
    }

    view.addSubview(goalTimeView)
    goalTimeView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(126)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
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

  // 로컬 UI 동작만 남김 (리액터와 무관)
  public override func action() {
    super.action()

    // 뒤로가기 (로컬)
    backButton.rx.tap
      .subscribe(with: self) { obj, _ in
        obj.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)

    // 키보드에 맞춰 버튼 올리기 (로컬)
    RxKeyboard.instance.visibleHeight
      .skip(1)
      .drive(with: self) { obj, height in
        let safeBottom = obj.view.safeAreaInsets.bottom
        let inset = height > 0 ? height + 12 - safeBottom : 12
        obj.nextButton.snp.updateConstraints {
          $0.bottom.equalTo(obj.view.safeAreaLayoutGuide).inset(inset)
        }
        obj.view.layoutIfNeeded()
      }
      .disposed(by: disposeBag)
  }

  public func bind(reactor: Reactor) {
    // Actions -> Reactor
    rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
      .take(1)
      .map { _ in Reactor.Action.initialize }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 저장 버튼: 현재 보이는 뷰 기준으로 시간/거리 매핑
    nextButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .map { owner, _ -> Reactor.Action in
        return .save(timeMinutes: owner.goalTimeView.currentCount, distanceMeter: nil)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State -> UI
    reactor.state.map(\.isLoading)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(with: self) { owner, loading in
        owner.nextButton.isEnabled = !loading
        owner.nextButton.alpha = loading ? 0.6 : 1.0
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isSaved)
      .distinctUntilChanged()
      .filter { $0 }
      .observe(on: MainScheduler.instance)
      .subscribe(with: self) { owner, _ in
        owner.showGoalSaveAlert()
      }
      .disposed(by: disposeBag)

    // 초기 프로필 로드 → UI 주입 (goal 옵셔널 안전 처리 + m→km 변환)
    reactor.state.map(\.profileInfo)
      .compactMap { $0 }
      .take(1)
      .observe(on: MainScheduler.instance)
      .subscribe(with: self) { owner, profile in
        owner.goalTimeView.setCount(Int((profile.goal.timeGoal ?? 30000) / 60000))
      }
      .disposed(by: disposeBag)
  }

  private func showGoalSaveAlert() {
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
          completion: { [weak self] _ in
            self?.goalSaveAlertView.isHidden = true
            self?.coordinator?.pop()
          }
        )
      }
    )
  }
}
