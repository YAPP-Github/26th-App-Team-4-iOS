//
//  MyPageViewController.swift
//  Presentation
//
//  Created by JDeoks on 8/11/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public final class MyPageViewController: BaseViewController {
  
  enum Section: Int, CaseIterable {
    case userInfo
    case goal
    case setting
    case service
    
    var displayName: String {
      switch self {
      case .userInfo:
        return ""
      case .goal:
        return "러닝 목표"
      case .setting:
        return "설정"
      case .service:
        return "서비스"
      }
    }
    
    var item: [Item] {
      switch self {
      case .userInfo:
        return [.userInfo]
      case .goal:
        return [.goalDistance, .goalTime, .goalPace, .runningCount]
      case .setting:
        return [.runningSetting, .notificationSetting, .acessibilitySetting]
      case .service:
        return [.termOfService, .serviceGuide, .version]
      }
    }
  }
  
  enum Item {
    case userInfo
    
    case goalDistance
    case goalTime
    case goalPace
    case runningCount
    
    case runningSetting
    case notificationSetting
    case acessibilitySetting
    
    case termOfService
    case serviceGuide
    case version
  }
  
  var coordinator: MyPageCoordinator?
  
  let navLabel = UILabel().then {
    $0.text = "마이페이지"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.Fg.Text.primary
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = .clear
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.sectionHeaderTopPadding = 0

    $0.registerCell(ofType: MyUserInfoTableCell.self)
    
    $0.delegate = self
    $0.dataSource = self
  }
  
  public override func initUI() {
    super.initUI()
    self.navigationController?.navigationBar.isHidden = true
    view.backgroundColor = FRColor.Bg.secondary
    
    view.addSubview(navLabel)
    navLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(56)
    }
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(navLabel.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Section.allCases[section].item.count
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let section = Section(rawValue: section)
    switch section {
    case .userInfo:
      return nil
    case .goal, .setting, .service:
      return MyPageMenuTableHeaderView(title: section!.displayName)
    case .none:
      return nil
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .userInfo:
      return 0
    case .goal, .setting, .service:
      return 92
    case .none:
      return 0
    }
  }
  
  // 모든 섹션 푸터 없애기
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .userInfo:
      return 0
    case .goal, .setting, .service:
      return 16
    case .none:
      return 0
    }
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section) {
    case .userInfo:
      return dequeueUserInfoCell(for: indexPath)
    case .goal:
     return dequeueUserInfoCell(for: indexPath)
    case .setting:
      return dequeueUserInfoCell(for: indexPath)
    case .service:
      return dequeueUserInfoCell(for: indexPath)
    case .none:
      return UITableViewCell()
    }
  }
  
  private func dequeueUserInfoCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyUserInfoTableCell.identifier, for: indexPath
    ) as! MyUserInfoTableCell
    cell.selectionStyle = .none
    return cell
  }
}
