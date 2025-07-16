//
//  BaseTableViewCell.swift
//  Core
//
//  Created by JDeoks on 7/12/25.
//


import UIKit
import RxSwift

open class BaseTableViewCell: UITableViewCell {
  
  public var disposeBag = DisposeBag()
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    initUI()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  open func initUI() {
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
  }
}
