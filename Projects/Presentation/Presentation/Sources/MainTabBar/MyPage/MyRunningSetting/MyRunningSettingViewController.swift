//
//  MyRunningSettingViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/13/25.
//

import UIKit
import Core
import ReactorKit
import Domain

public final class MyRunningSettingViewController: BaseViewController {
  
  enum Item: Int, CaseIterable {
    case audioCoaching
    case audioFeedback
    
    var title: String {
      switch self {
      case .audioCoaching:
        return "오디오 코칭"
      case .audioFeedback:
        return "오디오 피드백"
      }
    }
    
    var description: String {
      switch self {
      case .audioCoaching:
        return "러닝 중 올바른 자세에 대한 안내가 음성으로 제공되는 기능이에요"
      case .audioFeedback:
        return "러닝 중 실시간 페이스에 따라 맞춤형 안내가 음성으로 제공되는 기능이에요"
      }
    }
  }
  
  var coordinator: MyPageCoordinator?
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private let navLabel = UILabel().then { // 20
    $0.text = "러닝 설정"
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .none
    $0.alwaysBounceVertical = false
    
    $0.registerCell(ofType: MyRunningSettingTableCell.self)
    
    $0.delegate = self
    $0.dataSource = self
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
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(navLabel.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
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

extension MyRunningSettingViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Item.allCases.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = Item.allCases[indexPath.row]
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyRunningSettingTableCell.identifier, for: indexPath
    ) as! MyRunningSettingTableCell
    cell.setData(title: item.title, desc: item.description, isOn: false)
    return cell
  }
}
