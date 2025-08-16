//
//  MyGoalSegmentView.swift
//  Presentation
//
//  Created by JDeoks on 8/15/25.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

import Core

public final class MyGoalSegmentView: BaseView {

  public enum Segment: Int, CaseIterable {
    case goalTime = 0
    case goalDistance = 1

    var title: String {
      switch self {
      case .goalTime: return "목표 시간"
      case .goalDistance: return "목표 거리"
      }
    }
  }

  // MARK: - UI
  private lazy var stackView = UIStackView(arrangedSubviews: [paceLabel, countLabel]).then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.spacing = 4
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
  }

  private let paceLabel = UILabel().then {
    $0.text = Segment.goalTime.title
    $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.textAlignment = .center
    $0.isUserInteractionEnabled = true
  }

  private let countLabel = UILabel().then {
    $0.text = Segment.goalDistance.title
    $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.textAlignment = .center
    $0.isUserInteractionEnabled = true
  }

  private let indicatorView = UIView().then {
    $0.backgroundColor = FRColor.Bg.primary
    $0.layer.cornerRadius = 19
    $0.addShadow()
  }

  // MARK: - Output

  public let selectedSegment = BehaviorRelay<Segment>(value: .goalTime)

  // MARK: - State

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func initUI() {
    super.initUI()
    self.layer.cornerRadius = 23
    backgroundColor = .init(hex: "#F7F8F9")
    
    addSubview(indicatorView)
    addSubview(stackView)

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(4)
      $0.height.equalTo(38)
    }

    indicatorView.snp.makeConstraints {
      $0.edges.equalTo(paceLabel).inset(-4)
    }
  }
  
  public override func action() {
    super.action()
    
    paceLabel.rx.tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak self] _ in
        self?.switchTo(segment: .goalTime)
      })
      .disposed(by: disposeBag)

    countLabel.rx.tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak self] _ in
        self?.switchTo(segment: .goalDistance)
      })
      .disposed(by: disposeBag)
  }

  private func switchTo(segment: Segment) {
    guard segment != selectedSegment.value else { return }
    selectedSegment.accept(segment)

    let targetLabel = segment == .goalTime ? paceLabel : countLabel

    UIView.animate(withDuration: 0.25) {
      self.indicatorView.snp.remakeConstraints {
        $0.edges.equalTo(targetLabel).inset(-4)
      }
      self.layoutIfNeeded()
    }
  }
}
