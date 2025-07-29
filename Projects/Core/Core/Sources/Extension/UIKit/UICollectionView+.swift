//
//  UICollectionViewCell+.swift
//  Core
//
//  Created by JDeoks on 7/29/25.
//


import UIKit

extension UICollectionView {
  public func registerCell<T: UICollectionViewCell>(ofType type: T.Type) {
    let identifier = String(describing: type)
    self.register(type, forCellWithReuseIdentifier: identifier)
  }
}
