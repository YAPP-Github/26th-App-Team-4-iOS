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
  
  // MARK: - Properties
  public let cellView = SummaryTableViewCell()
  
  public override func initUI() {
    super.initUI()
    self.view.backgroundColor = .white
    view.addSubview(cellView)

    cellView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(20)
    }
  }
}
