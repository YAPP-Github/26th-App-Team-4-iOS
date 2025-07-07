//
//  BaseTableViewCell.swift
//  Core
//
//  Created by JDeoks on 7/7/25.
//


import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
  
  var disposeBag = DisposeBag()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    initUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  func initUI() {
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
  }
}