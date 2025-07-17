//
//  UIImage+.swift
//  Core
//
//  Created by dong eun shin on 7/18/25.
//

import UIKit

extension UIImage {
  public func resized(to newSize: CGSize) -> UIImage? {
    let format = UIGraphicsImageRendererFormat()
    format.scale = scale // 원본 이미지의 스케일 유지 (ex: @2x, @3x)
    format.opaque = false // 투명도 유지

    let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
    let image = renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
    return image
  }
}
