//
//  UIColor+.swift
//  Core
//
//  Created by JDeoks on 7/12/25.
//


import UIKit

public extension UIColor {
  convenience init(hex: String, alpha: CGFloat = 1.0) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  static func loadColor(named name: String) -> UIColor {
    guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
      fatalError("Color asset '\(name)' not found in asset catalog.")
    }
    return color
  }
}

public extension UIColor {
  static let baseBlack = UIColor.loadColor(named: "BaseBlack")
  static let baseWhite = UIColor.loadColor(named: "BaseWhite")
  static let baseGray = UIColor.loadColor(named: "BaseGray")

  static let gray0 = UIColor.loadColor(named: "Gray0")
  static let gray100 = UIColor.loadColor(named: "Gray100")
  static let gray200 = UIColor.loadColor(named: "Gray200")
  static let gray300 = UIColor.loadColor(named: "Gray300")
  static let gray400 = UIColor.loadColor(named: "Gray400")
  static let gray500 = UIColor.loadColor(named: "Gray500")
  static let gray600 = UIColor.loadColor(named: "Gray600")
  static let gray700 = UIColor.loadColor(named: "Gray700")
  static let gray800 = UIColor.loadColor(named: "Gray800")
  static let gray900 = UIColor.loadColor(named: "Gray900")
  static let gray1000 = UIColor.loadColor(named: "Gray1000")

  static let red100 = UIColor.loadColor(named: "Red100")
  static let red200 = UIColor.loadColor(named: "Red200")
  static let red300 = UIColor.loadColor(named: "Red300")
  static let red400 = UIColor.loadColor(named: "Red400")
  static let red500 = UIColor.loadColor(named: "Red500")
  static let red600 = UIColor.loadColor(named: "Red600")
  static let red700 = UIColor.loadColor(named: "Red700")
  static let red800 = UIColor.loadColor(named: "Red800")
  static let red900 = UIColor.loadColor(named: "Red900")
  static let red1000 = UIColor.loadColor(named: "Red1000")

  static let redOrange100 = UIColor.loadColor(named: "RedOrange100")
  static let redOrange200 = UIColor.loadColor(named: "RedOrange200")
  static let redOrange300 = UIColor.loadColor(named: "RedOrange300")
  static let redOrange400 = UIColor.loadColor(named: "RedOrange400")
  static let redOrange500 = UIColor.loadColor(named: "RedOrange500")
  static let redOrange600 = UIColor.loadColor(named: "RedOrange600")
  static let redOrange700 = UIColor.loadColor(named: "RedOrange700")
  static let redOrange800 = UIColor.loadColor(named: "RedOrange800")
  static let redOrange900 = UIColor.loadColor(named: "RedOrange900")
  static let redOrange1000 = UIColor.loadColor(named: "RedOrange1000")

  static let whiteAlpha50 = UIColor.loadColor(named: "WhiteAlpha50")
  static let whiteAlpha100 = UIColor.loadColor(named: "WhiteAlpha100")
  static let whiteAlpha200 = UIColor.loadColor(named: "WhiteAlpha200")
  static let whiteAlpha300 = UIColor.loadColor(named: "WhiteAlpha300")
  static let whiteAlpha400 = UIColor.loadColor(named: "WhiteAlpha400")
  static let whiteAlpha500 = UIColor.loadColor(named: "WhiteAlpha500")
  static let whiteAlpha600 = UIColor.loadColor(named: "WhiteAlpha600")
  static let whiteAlpha700 = UIColor.loadColor(named: "WhiteAlpha700")
  static let whiteAlpha800 = UIColor.loadColor(named: "WhiteAlpha800")
  static let whiteAlpha900 = UIColor.loadColor(named: "WhiteAlpha900")

  static let blue100 = UIColor.loadColor(named: "Blue100")
  static let blue200 = UIColor.loadColor(named: "Blue200")
  static let blue300 = UIColor.loadColor(named: "Blue300")
  static let blue400 = UIColor.loadColor(named: "Blue400")
  static let blue500 = UIColor.loadColor(named: "Blue500")
  static let blue600 = UIColor.loadColor(named: "Blue600")
  static let blue700 = UIColor.loadColor(named: "Blue700")
  static let blue800 = UIColor.loadColor(named: "Blue800")
  static let blue900 = UIColor.loadColor(named: "Blue900")
  static let blue1000 = UIColor.loadColor(named: "Blue1000")

  static let blackAlpha100 = UIColor.loadColor(named: "BlackAlpha100")
  static let blackAlpha200 = UIColor.loadColor(named: "BlackAlpha200")
  static let blackAlpha300 = UIColor.loadColor(named: "BlackAlpha300")
  static let blackAlpha400 = UIColor.loadColor(named: "BlackAlpha400")
  static let blackAlpha500 = UIColor.loadColor(named: "BlackAlpha500")
  static let blackAlpha600 = UIColor.loadColor(named: "BlackAlpha600")
  static let blackAlpha700 = UIColor.loadColor(named: "BlackAlpha700")
  static let blackAlpha800 = UIColor.loadColor(named: "BlackAlpha800")
  static let blackAlpha900 = UIColor.loadColor(named: "BlackAlpha900")
}
