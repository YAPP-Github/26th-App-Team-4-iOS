//
//  MyLevelSettingViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/12/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public final class MyLevelSettingViewController: BaseViewController, View {
  
  public typealias Reactor = MyLevelSettingReactor
  
  var coordinator: MyPageCoordinator?
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let navLabel = UILabel().then { // 20
    $0.text = "러닝 레벨 변경"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "변경하실 러닝\n레벨을 선택해주세요."
    $0.font = .systemFont(ofSize: 24, weight: .semibold)
    $0.textColor = FRColor.Fg.Text.primary
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let descLabel = UILabel().then {
    $0.text = "지금 나의 체력에 맞는 레벨로 다시 설정해보세요."
    $0.font = .systemFont(ofSize: 16, weight: .regular)
    $0.textColor = FRColor.Fg.Text.tertiary
  }
  
  private lazy var selectHStack = UIStackView(
    arrangedSubviews: [selectView0, selectView1, selectView2]
  ).then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  let selectView0 = MyPageSelectView().then {
    $0.setData(image: "🐣", title: "가볍게 달리는\n워밍업 러너", isSelected: true)
  }
  let selectView1 = MyPageSelectView().then {
    $0.setData(image: "⏱️", title: "꾸준히 달리는\n루틴 러너", isSelected: false)
  }
  
  let selectView2 = MyPageSelectView().then {
    $0.setData(image: "🚀", title: "성장 중인\n챌린저 러너", isSelected: false)
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
    
    view.addSubview(selectHStack)
    selectHStack.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(44)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(124)
    }
    
    view.addSubview(saveButton)
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(56)
    }
  }
  
  public func bind(reactor: MyLevelSettingReactor) {
    self.rx.viewDidLoad
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)
    
    selectView0.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectLevel(.beginner))
      }
      .disposed(by: disposeBag)
    
    selectView1.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectLevel(.intermediate))
      }
      .disposed(by: disposeBag)
    
    selectView2.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.selectLevel(.expert))
      }
      .disposed(by: disposeBag)
    
    saveButton.rx.tap
      .subscribe(with: self) { owner, _ in
        reactor.action.onNext(.save)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.level)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(with: self) { owner, purpose in
        owner.selectView0.setSelected(isSelected: purpose == .beginner)
        owner.selectView1.setSelected(isSelected: purpose == .intermediate)
        owner.selectView2.setSelected(isSelected: purpose == .expert)
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
