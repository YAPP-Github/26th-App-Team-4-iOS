//
//  UIView+.swift
//  Core
//
//  Created by JDeoks on 7/18/25.
//


import UIKit

extension UIView {
  public func addShadow(color: UIColor = .black, Opacity: Float = 0.10, Offset: CGSize = .init(width: 0, height: 2), radius: CGFloat = 10) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOpacity = Opacity
    self.layer.shadowOffset = Offset
    self.layer.shadowRadius = radius
  }
}
