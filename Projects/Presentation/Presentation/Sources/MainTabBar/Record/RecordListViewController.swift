//
//  RecordListViewController.swift
//  Presentation
//
//  Created by JDeoks on 7/25/25.
//

import UIKit
import Core
import ReactorKit
import NMapsMap
import Domain

public final class RecordListViewController: BaseViewController, View {
  
  public typealias Reactor = RecordListReactor
  
  weak var coordinator: RecordCoordinator?
  
  enum Section: Int, CaseIterable {
    case header
    case recordList
  }
  
  private let navTitleLabel = UILabel().then {
    $0.text = "기록"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.FG.Text.primary
  }
  
  private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.backgroundColor = FRColor.BG.primary
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.sectionHeaderTopPadding = 0

    $0.registerCell(ofType: RecordListHeaderTableCell.self)
    $0.registerCell(ofType: RecordListTableCell.self)
    
    $0.delegate = self
    $0.dataSource = self
  }
  
  public override func initUI() {
    super.initUI()
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = .white
    
    view.addSubview(navTitleLabel)
    navTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(24)
    }
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(navTitleLabel.snp.bottom).offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  public func bind(reactor: RecordListReactor) {
    self.rx.viewDidAppear
      .take(1)
      .map { _ in Reactor.Action.initialize }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map(\.summary)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(with: self) { owner, summary in
        guard let summary = summary else { return }
        // 섹션 0만 리로드
        owner.tableView.reloadSections(IndexSet(integer: Section.header.rawValue), with: .none)
      }
      .disposed(by: self.disposeBag)
    
    reactor.state.map(\.records)
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(with: self) { owner, records in
        // 섹션 1만 리로드
        owner.tableView.reloadSections(IndexSet(integer: Section.recordList.rawValue), with: .none)
      }
      .disposed(by: self.disposeBag)
  }
}

extension RecordListViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return Section.allCases.count
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section(rawValue: section) {
    case .header: return 1
    case .recordList: return 10
    case .none: return 0
    }
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard Section(rawValue: section) == .recordList else { return nil }
    return UIView().then {
      $0.backgroundColor = FRColor.BG.secondary
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch Section(rawValue: section) {
    case .recordList: return 32
    default: return .zero
    }
  }
  
  // 모든 섹션 푸터 없애기
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch Section(rawValue: indexPath.section) {
    case .header:
      return dequeueHeaderCell(for: indexPath)
    case .recordList:
      return dequeueRecordCell(for: indexPath)
    case .none:
      return UITableViewCell()
    }
  }
  
  private func dequeueHeaderCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordListHeaderTableCell.identifier, for: indexPath
    ) as! RecordListHeaderTableCell
    guard let summary = self.reactor?.currentState.summary else { return cell }
    cell.setData(summary: summary)
    return cell
  }
  
  private func dequeueRecordCell(for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordListTableCell.identifier, for: indexPath
    ) as! RecordListTableCell
    return cell
  }
}
