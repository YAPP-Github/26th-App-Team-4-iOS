//
//  UIImage+.swift
//  Core
//
//  Created by dong eun shin on 7/18/25.
//

import UIKit

extension UIImage {
  public func resized(to targetSize: CGSize) -> UIImage? {
    let aspectWidth = targetSize.width / size.width
    let aspectHeight = targetSize.height / size.height
    let aspectRatio = min(aspectWidth, aspectHeight)

    let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)

    let renderer = UIGraphicsImageRenderer(size: targetSize)
    return renderer.image { _ in
      let origin = CGPoint(x: (targetSize.width - newSize.width) / 2,
                           y: (targetSize.height - newSize.height) / 2)
      self.draw(in: CGRect(origin: origin, size: newSize))
    }
  }

  public func resizedToFill(to targetSize: CGSize) -> UIImage? {
    let originalAspect = self.size.width / self.size.height
    let targetAspect = targetSize.width / targetSize.height

    var newSize: CGSize
    if originalAspect > targetAspect {
      newSize = CGSize(width: targetSize.height * originalAspect, height: targetSize.height)
    } else {
      newSize = CGSize(width: targetSize.width, height: targetSize.width / originalAspect)
    }

    let renderer = UIGraphicsImageRenderer(size: targetSize)
    return renderer.image { _ in
      let origin = CGPoint(x: (targetSize.width - newSize.width) / 2,
                           y: (targetSize.height - newSize.height) / 2)
      self.draw(in: CGRect(origin: origin, size: newSize))
    }
  }
}
