//
//  MyPurposeSettingViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public final class MyPurposeSettingViewController: BaseViewController, View {
  
  public typealias Reactor = MyPurposeSettingReactor
  
  var coordinator: MyPageCoordinator?

  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let navLabel = UILabel().then { // 20
    $0.text = "러닝 목적 변경"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "변경하실 러닝\n목적을 선택해주세요."
    $0.font = .systemFont(ofSize: 24, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let descLabel = UILabel().then {
    $0.text = "이유가 분명할수록 꾸준히 달릴 수 있어요."
    $0.font = .systemFont(ofSize: 16, weight: .regular)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private lazy var selectVStack = UIStackView(
    arrangedSubviews: [selectHStack1, selectHStack2]
  ).then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  private lazy var selectHStack1 = UIStackView(
    arrangedSubviews: [selectView0, selectView1]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  private lazy var selectHStack2 = UIStackView(
    arrangedSubviews: [selectView2, selectView3]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  let selectView0 = MyPageSelectView().then {
    $0.setData(image: "🔥", title: "다이어트", isSelected: true)
  }
  let selectView1 = MyPageSelectView().then {
    $0.setData(image: "💓", title: "건강 관리", isSelected: false)
  }
  let selectView2 = MyPageSelectView().then {
    $0.setData(image: "🔋", title: "체력 증진", isSelected: false)
  }
  let selectView3 = MyPageSelectView().then {
    $0.setData(image: "🥇", title: "대회 준비", isSelected: false)
  }
  
  private let saveButton = UIButton().then {
    $0.setTitle("설정하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.backgroundColor = UIColor(hex: "#FF6600")
    $0.layer.cornerRadius = 16
  }

  
  override init() {
    super.init()
    hidesBottomBarWhenPushed = true
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func initUI() {
    super.initUI()
    view.backgroundColor = FRColor.Bg.primary
    
    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(24)
    }
    
    view.addSubview(navLabel)
    navLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(56)
    }

    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(navLabel.snp.bottom).offset(80)
      $0.centerX.equalToSuperview()
    }
    
    view.addSubview(descLabel)
    descLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }
    
    view.addSubview(selectVStack)
    selectVStack.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(44)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    selectHStack1.snp.makeConstraints {
      $0.height.equalTo(100)
    }
    
    selectHStack2.snp.makeConstraints {
      $0.height.equalTo(100)
    }
    
    view.addSubview(saveButton)
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(56)
    }
  }
  
  public func bind(reactor: MyPurposeSettingReactor) {
    self.rx.viewDidLoad
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)
    
    selectView0.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectPurpose(.weightLoss))
      }
      .disposed(by: disposeBag)
    
    selectView1.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectPurpose(.health))
      }
      .disposed(by: disposeBag)
    
    selectView2.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectPurpose(.endurance))
      }
      .disposed(by: disposeBag)
    
    selectView3.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectPurpose(.competitionPreparation))
      }
      .disposed(by: disposeBag)
    
    saveButton.rx.tap
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.save)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.purpose)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(with: self) { owner, purpose in
        owner.selectView0.setSelected(isSelected: purpose == .weightLoss)
        owner.selectView1.setSelected(isSelected: purpose == .health)
        owner.selectView2.setSelected(isSelected: purpose == .endurance)
        owner.selectView3.setSelected(isSelected: purpose == .competitionPreparation)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.isSaved)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(with: self) { owner, isSaved in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  public override func action() {
    super.action()
    
    backButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
