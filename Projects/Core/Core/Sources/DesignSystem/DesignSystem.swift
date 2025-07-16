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
