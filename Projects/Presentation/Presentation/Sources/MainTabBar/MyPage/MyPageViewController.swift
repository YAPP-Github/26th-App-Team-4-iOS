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
import SafariServices

public final class MyPageViewController: BaseViewController, View {
  
  enum Section: Int, CaseIterable {
    case userInfo
    case goal
    case setting
    case service
    case footer
    
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
      case .footer:
        return ""
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
      case .footer:
        return [.footer]
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
    
    case footer
    
    var title: String {
      switch self {
      case .userInfo:
        return ""
        
      case .goalDistance:
        return "목표 거리"
      case .goalTime:
        return "목표 시간"
      case .goalPace:
        return "목표 페이스"
      case .runningCount:
        return "러닝 횟수"
        
      case .runningSetting:
        return "러닝 설정"
      case .notificationSetting:
        return "알림 설정"
      case .acessibilitySetting:
        return "권한 설정"
        
      case .termOfService:
        return "약관관리"
      case .serviceGuide:
        return "서비스 이용 안내"
      case .version:
        return "앱 버전"
        
      case .footer:
        return ""
      }
    }
    
    var image: UIImage? {
      switch self {
      case .goalDistance:
        return UIImage(named: "MyPageTrack", in: Bundle.module, compatibleWith: nil)
      case .goalTime:
        return UIImage(named: "MyPageClock", in: Bundle.module, compatibleWith: nil)
      case .goalPace:
        return UIImage(named: "MyPageTarget", in: Bundle.module, compatibleWith: nil)
      case .runningCount:
        return UIImage(named: "MyPageRun", in: Bundle.module, compatibleWith: nil)
      default:
        return nil
      }
    }
  }
  
  public typealias Reactor = MyPageReactor
  
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
    $0.registerCell(ofType: MyPageGoalTableCell.self)
    $0.registerCell(ofType: MyPageMenuTableCell.self)
    $0.registerCell(ofType: MyPageFooterTableCell.self)
    
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

  public func bind(reactor: MyPageReactor) {
    print("\(type(of: self)) - \(#function)")

    self.rx.viewWillAppear
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.profileInfo)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .distinctUntilChanged()
      .subscribe(with: self) { owner, userInfo in
        owner.tableView.reloadData()
      }
      .disposed(by: disposeBag)
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
    case .userInfo, .footer:
      return nil
    case .goal, .setting, .service:
      return MyPageMenuTableHeaderView(title: section!.displayName)
    case .none:
      return nil
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .userInfo, .footer:
      return 0
    case .goal, .setting, .service:
      return 92
    case .none:
      return 0
    }
  }
  
  // 모든 섹션 푸터 없애기
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return MyPageMenuTableFooterView()
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .userInfo, .footer:
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
     return dequeueGoalCell(for: indexPath)
    case .setting:
      return dequeueMenuCell(for: indexPath)
    case .service:
      return dequeueMenuCell(for: indexPath)
    case .footer:
      return dequeueFooterCell(for: indexPath)
    case .none:
      return UITableViewCell()
    }
  }
  
  private func dequeueUserInfoCell(for indexPath: IndexPath) -> MyUserInfoTableCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyUserInfoTableCell.identifier, for: indexPath
    ) as! MyUserInfoTableCell
    
    if let profileInfo = reactor?.currentState.profileInfo {
      cell.setData(profileInfo: profileInfo)
    }
    
    cell.topHStack.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        owner.coordinator?.showMyProfile()
      }
      .disposed(by: cell.disposeBag)
    
    cell.healthLevelHStack.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        owner.coordinator?.showMyLevelSetting()
      }
      .disposed(by: cell.disposeBag)
    
    cell.goalHStack.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        owner.coordinator?.showMyPurposeSetting()
      }
      .disposed(by: cell.disposeBag)
    return cell
  }

  private func dequeueGoalCell(for indexPath: IndexPath) -> MyPageGoalTableCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyPageGoalTableCell.identifier, for: indexPath
    ) as! MyPageGoalTableCell

    guard let goalInfo = reactor?.currentState.profileInfo?.goal else {
      return cell
    }

    let item = Section.allCases[indexPath.section].item[indexPath.row]
    let value: String? = {
      switch item {
      case .goalDistance:
        guard let distanceMeterGoal = goalInfo.distanceMeterGoal else {
          return nil
        }
        return "\(Int(distanceMeterGoal) / 1000)km"

      case .goalTime:
        guard let timeGoal = goalInfo.timeGoal else {
          return nil
        }
        return "\(timeGoal)분"

      case .goalPace:
        guard let paceGoalMs = goalInfo.paceGoal else {
          return nil
        }
        let paceGoal = paceGoalMs / 1000
        let minutes = paceGoal / 60
        let seconds = paceGoal % 60
        return "\(minutes)'\(String(format: "%02d", seconds))\""

      case .runningCount:
        guard let weeklyRunningCount = goalInfo.weeklyRunningCount else {
          return nil
        }
        return "주 \(weeklyRunningCount)회"

      default:
        return nil
      }
    }()

    cell.setData(item: item, value: value)
    
    cell.contentView.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        switch item {
        case .goalDistance:
          owner.coordinator?.showMyGoalSettingVC()
        case .goalTime:
          owner.coordinator?.showMyGoalSettingVC()
        case .goalPace:
          owner.coordinator?.showPaceCountSettingVC()
        case .runningCount:
          owner.coordinator?.showPaceCountSettingVC()
        default:
          break
        }
      }
      .disposed(by: cell.disposeBag)
    
    return cell
  }
  private func dequeueMenuCell(for indexPath: IndexPath) -> MyPageMenuTableCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyPageMenuTableCell.identifier, for: indexPath
    ) as! MyPageMenuTableCell
    let item = Section.allCases[indexPath.section].item[indexPath.row]
    if item == .version {
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
      cell.setData(title: item.title, version: version)
    } else {
      cell.setData(title: item.title)
    }
    
    cell.contentView.rx.tapGesture()
      .when(.recognized)
      .subscribe(with: self) { owner, _ in
        switch item {
        case .runningSetting:
          owner.coordinator?.showRunningSetting()
          
        case .notificationSetting:
          owner.coordinator?.showMyNotiSettingVC()
          
        case .acessibilitySetting:
          if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
              UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
          }

        case .termOfService:
          let termsURL = "https://encouraging-romano-d7b.notion.site/251fb0e93b32801fbfc1c90bd48b36ff"
          guard let url = URL(string: termsURL) else { return }
          let safari = SFSafariViewController(url: url)
          owner.present(safari, animated: true)
          
        case .serviceGuide:
          let serviceGuideURL = "https://encouraging-romano-d7b.notion.site/251fb0e93b32808bbbcbee2c78b825d9"
          guard let url = URL(string: serviceGuideURL) else { return }
          let safari = SFSafariViewController(url: url)
          owner.present(safari, animated: true)
          
        default:
          break
        }
      }
      .disposed(by: cell.disposeBag)
    return cell
  }

  
  private func dequeueFooterCell(for indexPath: IndexPath) -> MyPageFooterTableCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MyPageFooterTableCell.identifier, for: indexPath
    ) as! MyPageFooterTableCell
    return cell
  }
}
