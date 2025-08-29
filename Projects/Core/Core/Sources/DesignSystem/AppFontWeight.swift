//
//  AppFontWeight.swift
//  Core
//
//  Created by dong eun shin on 8/29/25.
//

import UIKit

public enum AppFontWeight: String {
  case regular = "Pretendard-Regular"
  case medium = "Pretendard-Medium"
  case semibold = "Pretendard-SemiBold"
  case bold = "Pretendard-Bold"
  case heavyitalic = "SF-Pro-Text-HeavyItalicSF"
}

public struct AppTextStyle {
  public let font: UIFont
  public let lineHeight: CGFloat
  public let letterSpacing: CGFloat

  public init(font: UIFont, lineHeight: CGFloat, letterSpacing: CGFloat = 0) {
    self.font = font
    self.lineHeight = lineHeight
    self.letterSpacing = letterSpacing
  }
}

// MARK: - Typography
public struct AppTypography {

  // Headings
  public static let h1_bold = AppTextStyle(
    font: .pretendard(.bold, size: 26),
    lineHeight: 36,
    letterSpacing: -0.4
  )

  public static let h1_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 26),
    lineHeight: 36,
    letterSpacing: -0.4
  )

  public static let h2_bold = AppTextStyle(
    font: .pretendard(.bold, size: 24),
    lineHeight: 32,
    letterSpacing: -0.4
  )

  public static let h2_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 24),
    lineHeight: 32,
    letterSpacing: -0.4
  )

  public static let h3_bold = AppTextStyle(
    font: .pretendard(.bold, size: 22),
    lineHeight: 28,
    letterSpacing: -0.4
  )

  public static let h3_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 22),
    lineHeight: 28,
    letterSpacing: -0.4
  )

  public static let h4_bold = AppTextStyle(
    font: .pretendard(.bold, size: 20),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let h4_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 20),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let h5_bold = AppTextStyle(
    font: .pretendard(.bold, size: 18),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let h5_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 18),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let h6_bold = AppTextStyle(
    font: .pretendard(.bold, size: 16),
    lineHeight: 20,
    letterSpacing: -0.4
  )

  public static let h6_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 16),
    lineHeight: 20,
    letterSpacing: -0.4
  )


  // Body
  public static let body1_bold = AppTextStyle(
    font: .pretendard(.bold, size: 20),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body1_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 20),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body1_medium = AppTextStyle(
    font: .pretendard(.medium, size: 20),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body1_regular = AppTextStyle(
    font: .pretendard(.regular, size: 20),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body2_bold = AppTextStyle(
    font: .pretendard(.bold, size: 18),
    lineHeight: 28,
    letterSpacing: -0.4
  )

  public static let body2_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 18),
    lineHeight: 28,
    letterSpacing: -0.4
  )

  public static let body2_medium = AppTextStyle(
    font: .pretendard(.medium, size: 18),
    lineHeight: 28,
    letterSpacing: -0.4
  )

  public static let body2_regular = AppTextStyle(
    font: .pretendard(.regular, size: 18),
    lineHeight: 28,
    letterSpacing: -0.4
  )

  public static let body3_bold = AppTextStyle(
    font: .pretendard(.bold, size: 16),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body3_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 16),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body3_medium = AppTextStyle(
    font: .pretendard(.medium, size: 16),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body3_regular = AppTextStyle(
    font: .pretendard(.regular, size: 16),
    lineHeight: 24,
    letterSpacing: -0.4
  )

  public static let body4_bold = AppTextStyle(
    font: .pretendard(.bold, size: 14),
    lineHeight: 20,
    letterSpacing: -0.4
  )

  public static let body4_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 14),
    lineHeight: 20,
    letterSpacing: -0.4
  )

  public static let body4_medium = AppTextStyle(
    font: .pretendard(.medium, size: 14),
    lineHeight: 20,
    letterSpacing: -0.4
  )

  public static let body4_regular = AppTextStyle(
    font: .pretendard(.regular, size: 14),
    lineHeight: 20,
    letterSpacing: -0.4
  )

  // Captions
  public static let caption1_bold = AppTextStyle(
    font: .pretendard(.bold, size: 14),
    lineHeight: 20
  )

  public static let caption1_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 14),
    lineHeight: 20
  )

  public static let caption1_medium = AppTextStyle(
    font: .pretendard(.medium, size: 14),
    lineHeight: 20
  )

  public static let caption2_bold = AppTextStyle(
    font: .pretendard(.bold, size: 13),
    lineHeight: 20
  )

  public static let caption2_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 13),
    lineHeight: 20
  )

  public static let caption2_medium = AppTextStyle(
    font: .pretendard(.medium, size: 13),
    lineHeight: 20
  )

  public static let caption3_bold = AppTextStyle(
    font: .pretendard(.bold, size: 12),
    lineHeight: 16
  )

  public static let caption3_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 12),
    lineHeight: 16
  )

  public static let caption3_medium = AppTextStyle(
    font: .pretendard(.medium, size: 12),
    lineHeight: 16
  )

  public static let caption4_bold = AppTextStyle(
    font: .pretendard(.bold, size: 10),
    lineHeight: 16
  )

  public static let caption4_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 10),
    lineHeight: 16
  )

  public static let caption4_medium = AppTextStyle(
    font: .pretendard(.medium, size: 10),
    lineHeight: 16
  )

  // Numbers
  public static let number1_ios = AppTextStyle(
    font: UIFont(name: AppFontWeight.heavyitalic.rawValue, size: 100) ?? .systemFont(ofSize: 100, weight: .heavy),
    lineHeight: 110,
    letterSpacing: -0.4
  )

  public static let number2_extrabold = AppTextStyle(
    font: .pretendard(.bold, size: 48),
    lineHeight: 56,
    letterSpacing: -0.4
  )

  public static let number2_bold = AppTextStyle(
    font: .pretendard(.bold, size: 48),
    lineHeight: 56,
    letterSpacing: -0.4
  )

  public static let number2_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 48),
    lineHeight: 56,
    letterSpacing: -0.4
  )

  public static let number3_extrabold = AppTextStyle(
    font: .pretendard(.bold, size: 28),
    lineHeight: 36,
    letterSpacing: -0.4
  )

  public static let number3_bold = AppTextStyle(
    font: .pretendard(.bold, size: 28),
    lineHeight: 36,
    letterSpacing: -0.4
  )

  public static let number3_semibold = AppTextStyle(
    font: .pretendard(.semibold, size: 28),
    lineHeight: 36,
    letterSpacing: -0.4
  )
}
