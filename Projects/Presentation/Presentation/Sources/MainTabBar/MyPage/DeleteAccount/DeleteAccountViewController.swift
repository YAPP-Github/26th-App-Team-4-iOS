//
//  DeleteAccountViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//


import UIKit
import Core
import ReactorKit
import Domain

public final class DeleteAccountViewController: BaseViewController, View {
  
  public typealias Reactor = DeleteAccountReactor
  
  public enum Mode {
    case deleteAccountTerm
    case deleteAccountReason
  }
  
  enum Item {
    case termOfService
    
    case reason0
    case reason1
    case reason2
    case reason3
    case reason4
    case reason5
    case reasonEtc
    
    var text: String {
      switch self {
      case .termOfService:
        return "회원탈퇴 약관 동의"
      case .reason0:
        return "앱 기능이 생각보다 별로예요"
      case .reason1:
        return "자주 사용하지 않아요"
      case .reason2:
        return "러닝 목표를 달성했어요"
      case .reason3:
        return "건강 문제로 러닝을 포기할래요"
      case .reason4:
        return "다른 앱을 사용할래요"
      case .reason5:
        return "사용이 복잡하거나 불편해요"
      case .reasonEtc:
        return "기타"
      }
    }
  }
  
  var coordinator: MyPageCoordinator?

  let mode: Mode
  
  var tableItem: [Item] {
    if mode == .deleteAccountTerm {
      return [.termOfService]
    } else {
      return [.reason0, .reason1, .reason2, .reason3, .reason4, .reason5, .reasonEtc]
    }
  }
  
  private var selectedItem: Item? = nil
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let navLabel = UILabel().then { // 20
    $0.text = "탈퇴 약관동의"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private lazy var textVStack = UIStackView(
    arrangedSubviews: [titleVStack, descLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 12
    $0.alignment = .leading
  }
  
  private lazy var titleVStack = UIStackView(
    arrangedSubviews: [beforeDeleteLabel, confirmLabel]
  ).then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .leading
  }
  private let beforeDeleteLabel = UILabel().then { // 32
    $0.text = "회원탈퇴 전"
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = FRColor.Fg.Text.warning
  }
  
  private let confirmLabel = UILabel().then { // 32
    $0.text = "꼭 확인해 주세요!"
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private let descLabel = UILabel().then { // 32
    $0.text = "탈퇴 시 회원님의 러닝 기록, 목표 설정, 크루 정보 등 모든 데이터가 삭제됩니다. 신중히 결정해 주세요."
    $0.font = .systemFont(ofSize: 16, weight: .medium)
    $0.textColor = FRColor.Fg.Text.tertiary
    $0.numberOfLines = 0
  }
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .none
    $0.alwaysBounceVertical = false
    
    $0.registerCell(ofType: DeleteAccountTableCell.self)
    
    $0.delegate = self
    $0.dataSource = self
  }
  
  private let nextButton = UIButton().then {
    $0.setTitle("다음", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.backgroundColor = FRColor.Bg.disabled
    $0.layer.cornerRadius = 16
  }
  
  let alertView = DeleteAccountConfirmView().then  {
    $0.isHidden = true
  }

  init(mode: Mode) {
    self.mode = mode
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
    navLabel.text = mode == .deleteAccountTerm ? "탈퇴 약관동의" : "회원탈퇴"
    view.addSubview(textVStack)
    textVStack.snp.makeConstraints {
      $0.top.equalTo(navLabel.snp.bottom).offset(28)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(textVStack.snp.bottom).offset(24)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(56)
    }
    nextButton.setTitle(mode == .deleteAccountTerm ? "다음" : "탈퇴하기", for: .normal)
    
    view.addSubview(alertView)
    alertView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public func bind(reactor: DeleteAccountReactor) {
    print("\(type(of: self)) - \(#function)")

    reactor.state.map(\.accountDeleted)
      .observe(on: MainScheduler.instance)
      .filter { $0 }
      .subscribe(with: self) { owner, accountDeleted in
        print("reactor.state.map(accountDeleted)")
        // MARK: - 여기서 런치스크린 이동
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
    
    nextButton.rx.tap
      .subscribe(with: self) { owner, _ in
        if owner.mode == .deleteAccountTerm {
          if owner.selectedItem == .termOfService {
            owner.coordinator?.showDeleteAccount(mode: .deleteAccountReason)
            return
          }
        } else {
          owner.alertView.isHidden = false
        }
      }
      .disposed(by: disposeBag)
    
    alertView.onCancel = { [weak self] in
      print("alertView.onCancel")

      self?.alertView.isHidden = true
    }
    alertView.onConfirm = { [weak self] in
      print("alertView.onConfirm")
      self?.alertView.isHidden = true
      let reason = self?.selectedItem?.text ?? Item.reason0.text
      guard let reactor = self?.reactor else {
        print("alertView.onConfirm 리액터 없음")
        return
      }
      reactor.action.onNext(.deleteAccount(reason: reason))
    }
  }
  
  private func updateNextButtonState() {
    if mode == .deleteAccountTerm {
      let isValid = selectedItem == .termOfService
      nextButton.isEnabled = isValid
      nextButton.backgroundColor = isValid ? FRColor.Bg.Interactive.secondary : FRColor.Bg.disabled
    } else {
      let isValid = selectedItem != nil
      nextButton.isEnabled = isValid
      nextButton.backgroundColor = isValid ? FRColor.Bg.Interactive.secondary : FRColor.Bg.disabled
    }
  }
}

extension DeleteAccountViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableItem.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = tableItem[indexPath.row]
    let cell = tableView.dequeueReusableCell(
      withIdentifier: DeleteAccountTableCell.identifier, for: indexPath
    ) as! DeleteAccountTableCell
    cell.setData(text: item.text, isChecked: item == selectedItem, showTerms: mode == .deleteAccountTerm)
    
    cell.contentView.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        owner.selectedItem = item
        owner.tableView.reloadData()
        owner.updateNextButtonState()
      }
      .disposed(by: cell.disposeBag)
    
    cell.showTermsButton.rx.tap
      .subscribe(with: self) { owner, _ in
        // 이용약관 보이기
      }
      .disposed(by: cell.disposeBag)
    
    return cell
  }
}
