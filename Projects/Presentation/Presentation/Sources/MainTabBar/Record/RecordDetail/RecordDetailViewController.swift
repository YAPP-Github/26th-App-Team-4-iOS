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

public final class RecordDetailViewController: BaseViewController {
  
  enum Section: Int, CaseIterable {
    case title
    case runRecord
    case runningCourse
    case lapSegment
  }
  
  private let backButton = UIButton().then {
    $0.setImage(.init(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = FRColor.BG.primary
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.sectionHeaderTopPadding = 0

    $0.registerCell(ofType: RecordDetailTitleTableCell.self)
    
    $0.delegate = self
    $0.dataSource = self
  }
  
  public override func initUI() {
    super.initUI()
    self.view.backgroundColor = .white

    view.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(24)
    }
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
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
      
    case .runRecord:
      return 1
      
    case .runningCourse:
      return 1
      
    case .lapSegment:
      return 1
      
    case .none:
      return 1
    }
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return .zero
  }
  
  // 모든 섹션 푸터 없애기
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    switch Section(rawValue: indexPath.section) {
//    case .title:
//      return dequeueTitleCell(for: indexPath)
//      
//    case .runRecord:
//      return dequeueRecordCell(for: indexPath)
//      
//    case .runningCourse:
//      return dequeRueRunningCourseCell(for: indexPath)
//      
//    case .lapSegment:
//      return dequeRueRunningCourseCell(for: indexPath)
//      
//    case .none:
//      return UITableViewCell()
//    }
    return dequeueTitleCell(for: indexPath)
  }
  
  private func dequeueTitleCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordDetailTitleTableCell.identifier, for: indexPath
    ) as! RecordDetailTitleTableCell
    return cell
  }
  
  private func dequeueRecordCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordListTableCell.identifier, for: indexPath
    ) as! RecordListTableCell
    return cell
  }
  
  private func dequeRueRunningCourseCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordListTableCell.identifier, for: indexPath
    ) as! RecordListTableCell
    return cell
  }
  
  private func dequeueLapSegmentCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordListTableCell.identifier, for: indexPath
    ) as! RecordListTableCell
    return cell
  }
}
