//
//  WalkThroughViewController.swift
//  MaumNote_iOS
//
//  Created by JDeoks on 7/9/25.
//


//
//  WalkThroughViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/8/25.
//

import UIKit

import ReactorKit
import Then
import Core

public final class WalkThroughViewController: BaseViewController, View {
  
  weak var coordinator: WalkThroughCoordinator?

  private let pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.currentPage = 0
    $0.pageIndicatorTintColor = .gray
    $0.currentPageIndicatorTintColor = .black
  }
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
  }
  
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.isPagingEnabled = true

    $0.delegate = self
    $0.dataSource = self
    
    $0.registerCell(ofType: WalkThroughCollectionCell.self)
  }
  
  private let nextButton = UIButton().then {
    $0.setTitle("다음", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 16
  }
  
  public override func initUI() {
    super.initUI()
    
    view.addSubview(pageControl)
    pageControl.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.centerX.equalToSuperview()
    }
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(56)
    }
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalTo(pageControl.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(nextButton.snp.top).offset(-16)
    }
  }
  
  // MARK: - ReactorKit Bind
  public func bind(reactor: WalkThroughReactor) {

    nextButton.rx.tap
      .subscribe(with: self) { object, _ in
        guard let reactor = object.reactor else { return }
        if reactor.currentState.shouldShowStart {
          object.goToNextScreen()
        } else {
          reactor.action.onNext(.moveToNextPage)
        }
      }
      .disposed(by: disposeBag)

    // [3] 페이지 이동 반영
    reactor.state
      .map(\.currentPage)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] index in
        guard let self = self else { return }
        self.pageControl.currentPage = index
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      })
      .disposed(by: disposeBag)

    reactor.state.map(\.shouldShowStart)
      .distinctUntilChanged()
      .subscribe(with: self) { object, shouldShowStart in
        object.nextButton.setTitle(shouldShowStart ? "시작하기" : "다음", for: .normal)
      }
      .disposed(by: disposeBag)
  }

  private func goToNextScreen() {
    guard let coordinator = self.coordinator else { return }
    // WalkThrough 완료 후 시작 화면으로 이동
    coordinator.finishDelegate?.coordinatorDidFinish(childCoordinator: coordinator)
  }
}

extension WalkThroughViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return WalkThroughStep.allCases.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: WalkThroughCollectionCell.identifier,
      for: indexPath
    ) as! WalkThroughCollectionCell
    cell.setData(step: WalkThroughStep.allCases[indexPath.item])
    return cell
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.frame.size
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    let newIndex = Int(scrollView.contentOffset.x / width)
    guard let reactor = self.reactor else { return }
    reactor.action.onNext(.scrollToPage(newIndex))
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  // 섹션 간의 수직 간격 설정
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
  // 섹션 내 아이템 간의 수평 간격 설정
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
}
