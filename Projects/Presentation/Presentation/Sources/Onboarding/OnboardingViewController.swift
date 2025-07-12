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
  private var currentIndex = 0

  
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
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
  }

  private lazy var navStackView = UIStackView(
    arrangedSubviews: [backButton, progressView, nextButton]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 40
    $0.alignment = .center
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
      [pages[currentIndex]],
      direction: .forward,
      animated: false
    )

    pageVC.view.snp.makeConstraints {
      $0.top.equalTo(navStackView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }

    // disable swipe gesture
    for subview in pageVC.view.subviews {
      if let scrollView = subview as? UIScrollView {
        scrollView.isScrollEnabled = false
      }
    }
    
    updateProgress()
  }

  public func bind(reactor: OnboardingReactor) {
//    // Action
//    completeButton.rx.tap
//      .map { Reactor.Action.completeOnboardingTapped }
//      .bind(to: reactor.action)
//      .disposed(by: disposeBag)
//
//    // State
//    reactor.state.map { $0.isCompleted }
//      .filter { $0 }
//      .bind(onNext: { [weak self] _ in
//        self?.coordinator?.showMainTab()
//      })
//      .disposed(by: disposeBag)
  }
  
  public override func action() {
    backButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.goBack()
      }
      .disposed(by: disposeBag)
    
    nextButton.rx.tap
      .subscribe(with: self) { object, _ in
        object.goNext()
      }
      .disposed(by: disposeBag)
  }
  
  private func goNext() {
    guard currentIndex < pages.count - 1 else { return }
    let nextIndex = currentIndex + 1
    pageVC.setViewControllers(
      [pages[nextIndex]],
      direction: .forward,
      animated: true
    )
    currentIndex = nextIndex
    updateProgress()
  }
  
  private func goBack() {
    guard currentIndex > 0 else { return }
    let prevIndex = currentIndex - 1
    pageVC.setViewControllers(
      [pages[prevIndex]],
      direction: .reverse,
      animated: true
    )
    currentIndex = prevIndex
    updateProgress()
  }
  
  private func updateProgress() {
    let total = Float(pages.count)
    guard total > 0 else { return }
    progressView.setProgress(
      Float(currentIndex + 1) / total,
      animated: true
    )
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
