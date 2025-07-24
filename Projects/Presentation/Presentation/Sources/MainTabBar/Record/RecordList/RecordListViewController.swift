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

public final class RecordListViewController: BaseViewController {
  
  private let navTitleLabel = UILabel().then {
    $0.text = "기록"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = FRColor.FG.Text.primary
  }
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = FRColor.BG.primary
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.registerCell(ofType: RecordListTableCell.self)
    
    $0.delegate = self
    $0.dataSource = self
  }
  
  public override func initUI() {
    super.initUI()
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
}

extension RecordListViewController: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: RecordListTableCell.identifier,
      for: indexPath
    )
    return cell
  }
}
