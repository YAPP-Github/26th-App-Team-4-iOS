//
//  Int+.swift
//  Core
//
//  Created by dong eun shin on 8/13/25.
//

import Foundation

public extension Double {
  func toMinutesAndSeconds() -> String {
    let totalSeconds = Int(self / 1000)
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60

    return String(format: "%02d'%02d''", minutes, seconds)
  }

  func toTime() -> String {
    let totalSeconds = Int(self / 1000)
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60

    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}
