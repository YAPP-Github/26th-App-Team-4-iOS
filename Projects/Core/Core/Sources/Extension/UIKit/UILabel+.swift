//
//  UILabel+.swift
//  Core
//
//  Created by dong eun shin on 8/29/25.
//

import UIKit

public extension UILabel {
  func apply(style: AppTextStyle) {
    guard let text = self.text else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = style.lineHeight
    paragraphStyle.maximumLineHeight = style.lineHeight
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: style.font,
      .paragraphStyle: paragraphStyle,
      .kern: style.letterSpacing
    ]
    
    self.attributedText = NSAttributedString(string: text, attributes: attributes)
    self.numberOfLines = 0
  }
}
