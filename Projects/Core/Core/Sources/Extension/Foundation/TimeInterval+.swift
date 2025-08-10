//
//  TimeInterval+.swift
//  Core
//
//  Created by JDeoks on 7/31/25.
//

import Foundation

public extension TimeInterval {
  /// TimeInterval(초) → "분’초”" 포맷 문자열
  var minuteSecondFormatted: String {
    let totalSeconds = Int(self)
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    // %02d로 seconds를 두 자리로 포맷(7’05” 처럼)
    return String(format: "%d’%02d”", minutes, seconds)
  }
  
  /// TimeInterval(초) → "H:mm:ss" 포맷 문자열
  var hourMinuteSecondFormatted: String {
    let totalSeconds = Int(self)
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60
    return String(format: "%d:%02d:%02d", hours, minutes, seconds)
  }
}
