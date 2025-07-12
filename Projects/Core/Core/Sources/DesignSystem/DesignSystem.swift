//
//  DesignSystem.swift
//  Core
//
//  Created by dong eun shin on 7/4/25.
//

import UIKit

public struct DesignSystem {
    public static var Colors = ColorPalette()
    public static var Fonts = FontPalette()
}

public struct ColorPalette {
    public let primary = UIColor(hex: "#FF6633") // 예시 색상
    public let secondary = UIColor(hex: "#6699FF") // 예시 색상
    public let textPrimary = UIColor.label
    public let background = UIColor.systemBackground
}

public struct FontPalette {
    public let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    public let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
    public let body = UIFont.systemFont(ofSize: 17, weight: .regular)
}

extension UIColor {
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
}
