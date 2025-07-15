//
//  OnboardingViewController.swift
//  Presentation
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit
import Then

import Core

public final class OnboardingViewController: BaseViewController, View {

  weak var coordinator: OnboardingCoordinator?
  private var lastStepIdx = 0

  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }

  private let progressView = UIProgressView(progressViewStyle: .bar).then {
    $0.trackTintColor = UIColor.systemGray5
    $0.progressTintColor = UIColor.orange
    $0.layer.cornerRadius = 2
    $0.clipsToBounds = true
    $0.progress = 0
  }

  private let nextButton = UIButton(type: .system).then {
    $0.setTitle("다음", for: .normal)
    $0.setTitleColor(FRColor.FG.Icon.interactive.primary, for: .normal)
    $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
  }

  private lazy var navStackView = UIStackView(
    arrangedSubviews: [backButton, progressView, nextButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 40
    $0.alignment = .center
  }
  
  private let activityIndicator = UIActivityIndicatorView().then {
    $0.tintColor = FRColor.FG.Icon.interactive.primary
    $0.hidesWhenStopped = true
  }

  private lazy var pageVC = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil
  ).then {
    $0.dataSource = self
    $0.delegate = self
  }

  private lazy var pages = OnboardingStep.allCases.map {
    OnboardingPageViewController(step: $0)
  }

  public override func initUI() {
    super.initUI()

    view.backgroundColor = .white

    view.addSubview(navStackView)
    navStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    addChild(pageVC)
    view.addSubview(pageVC.view)
    pageVC.didMove(toParent: self)

    pageVC.setViewControllers(
      [pages[lastStepIdx]],
      direction: .forward,
      animated: false
    )

    pageVC.view.snp.makeConstraints {
      $0.top.equalTo(navStackView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }

    // 스와이프로 이동 방지
    for subview in pageVC.view.subviews {
      if let scrollView = subview as? UIScrollView {
        scrollView.isScrollEnabled = false
      }
    }
    
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  public func bind(reactor: OnboardingReactor) {
    // 페이지 뷰컨 이벤트 리액터에 전달
    pages.forEach { page in
      page.selection
        .map { OnboardingReactor.Action.select(question: $0.0, index: $0.1) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    backButton.rx.tap
      .map { OnboardingReactor.Action.moveBack }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    nextButton.rx.tap
      .map { OnboardingReactor.Action.moveNext }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.currentStep)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(with: self) { object, idx in
        object.handleStepChanged(stepIdx: idx)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.isNextEnabled)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(with: self) { object, enabled in
        object.nextButton.isEnabled = enabled
        object.nextButton.alpha = enabled ? 1 : 0.3
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.isLoading)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.isCompleted)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(with: self) { object, _ in
        object.showRunnerTypeVC()
      }
      .disposed(by: disposeBag)
  }
  
  private func handleStepChanged(stepIdx: Int) {
    let vc = self.pages[stepIdx]
    self.pageVC.setViewControllers(
      [ vc ],
      direction: stepIdx > lastStepIdx ? .forward : .reverse,
      animated: true
    )
    updateProgress(stepIdx: stepIdx)
    lastStepIdx = stepIdx
  }
  
  private func updateProgress(stepIdx: Int) {
    let total = Float(self.pages.count)
    self.progressView.setProgress(
      Float(stepIdx + 1) / total,
      animated: true
    )
  }
  
  private func showRunnerTypeVC() {
    let vc = RunnerTypeViewController()
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overFullScreen
    self.present(vc, animated: true)
  }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    return nil
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    return nil
  }
}
