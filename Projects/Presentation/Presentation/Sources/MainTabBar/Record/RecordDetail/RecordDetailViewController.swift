//
//  RecordDetailViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public final class RecordDetailViewController: BaseViewController, View {
  
  public typealias Reactor = RecordDetailReactor
  
  enum Section: Int, CaseIterable {
    case title
    case goalAchievement
    case runRecord
    case runningCourse
    case lapSegment
  }
  
  weak var coordinator: RecordCoordinator?
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = FRColor.Base.grey
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.sectionHeaderTopPadding = 0

    $0.registerCell(ofType: RecordDetailTitleTableCell.self)
    $0.registerCell(ofType: RecordDetailAchievementTableCell.self)
    $0.registerCell(ofType: RecordDetailRecordTableCell.self)
    $0.registerCell(ofType: RecordDetailCourseTableCell.self)
    $0.registerCell(ofType: RecordDetailLapTableCell.self)
    
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
    self.view.backgroundColor = FRColor.Base.grey

    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(24)
    }
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  public func bind(reactor: RecordDetailReactor) {
    self.rx.viewDidAppear
      .take(1)
      .subscribe(with: self) { object, _ in
        reactor.action.onNext(.initialize)
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

extension RecordDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section(rawValue: section) {
    case .title:
      return 1
    
    case .goalAchievement:
      return 1
      
    case .runRecord:
      return 1
      
    case .runningCourse:
      return 1
      
    case .lapSegment:
      return 5
      
    case .none:
      return 0

    }
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch Section(rawValue: section) {
    case .lapSegment:
      return RecordDetailLapTableHeaderView()
    default:
      return UIView()
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .lapSegment:
      return 94
    default:
      return .zero
    }
  }
  
  // 모든 섹션 푸터 없애기
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    switch Section(rawValue: section) {
    case .lapSegment:
      return RecordDetailLapTableFooterView()
    default:
      return UIView()
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .lapSegment:
      return 62
    default:
      return .zero
    }
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section) {
    case .title:
      return dequeueTitleCell(for: indexPath)
      
    case .goalAchievement:
      return dequeueGoalAchievementCell(for: indexPath)
      
    case .runRecord:
      return dequeueRecordCell(for: indexPath)
      
    case .runningCourse:
      return dequeRueRunningCourseCell(for: indexPath)
      
    case .lapSegment:
      return dequeueLapSegmentCell(for: indexPath)
      
    case .none:
      return UITableViewCell()
    }
  }
  
  private func dequeueTitleCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailTitleTableCell.identifier, for: indexPath
    ) as! RecordDetailTitleTableCell
    return cell
  }
  
  private func dequeueGoalAchievementCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailAchievementTableCell.identifier, for: indexPath
    ) as! RecordDetailAchievementTableCell
    return cell
  }
  
  private func dequeueRecordCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailRecordTableCell.identifier, for: indexPath
    ) as! RecordDetailRecordTableCell
    return cell
  }
  
  private func dequeRueRunningCourseCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailCourseTableCell.identifier, for: indexPath
    ) as! RecordDetailCourseTableCell
    return cell
  }
  
  private func dequeueLapSegmentCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailLapTableCell.identifier, for: indexPath
    ) as! RecordDetailLapTableCell
    return cell
  }
}
