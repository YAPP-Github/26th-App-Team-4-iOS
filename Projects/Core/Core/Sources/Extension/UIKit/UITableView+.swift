//
//  UITableView+.swift
//  Core
//
//  Created by JDeoks on 7/12/25.
//


import UIKit

extension UITableView {

  public func registerCell<T: UITableViewCell>(ofType type: T.Type) {
    let identifier = String(describing: type)
    self.register(type, forCellReuseIdentifier: identifier)
  }
  
}
