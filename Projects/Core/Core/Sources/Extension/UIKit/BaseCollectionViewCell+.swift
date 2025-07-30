//
//  BaseCollectionViewCell+.swift
//  Core
//
//  Created by JDeoks on 7/29/25.
//

import UIKit
import RxSwift

open class BaseCollectionViewCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConstraints()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  open override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  open func initConstraints() { }
}
