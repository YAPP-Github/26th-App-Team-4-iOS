//
//  UIFont+.swift
//  Core
//
//  Created by dong eun shin on 8/29/25.
//

import UIKit

public extension UIFont {
  static func pretendard(_ weight: AppFontWeight, size: CGFloat) -> UIFont {
    return UIFont(name: weight.rawValue, size: size)
    ?? .systemFont(ofSize: size, weight: {
      switch weight {
      case .regular:  return .regular
      case .medium:   return .medium
      case .semibold: return .semibold
      case .bold:     return .bold
      case .heavyitalic: return .heavy
      }
    }())
  }
}
