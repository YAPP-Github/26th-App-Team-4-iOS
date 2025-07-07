//
//  BaseCollectionViewCell.swift
//  Core
//
//  Created by JDeoks on 7/7/25.
//


import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  func initConstraints() { }
}