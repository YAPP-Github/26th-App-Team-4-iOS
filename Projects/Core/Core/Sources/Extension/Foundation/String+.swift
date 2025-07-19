//
//  String+.swift
//  Core
//
//  Created by JDeoks on 7/19/25.
//

import Foundation

public extension String {
  func paddingRight(toLength: Int, withPad character: Character) -> String {
    let padCount = max(0, toLength - self.count)
    return self + String(repeating: character, count: padCount)
  }
}
