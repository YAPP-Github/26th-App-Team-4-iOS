//
//  RunningRecordImageUseCase.swift
//  Domain
//
//  Created by dong eun shin on 8/2/25.
//

import UIKit
import RxSwift
import NMapsMap

public protocol RunningRecordImageUseCase {
  func generateMapImage(for record: RunningRecord?) -> Single<UIImage>
  func uploadImage(_ image: UIImage, recordId: Int) -> Single<String?>
}

public final class RunningRecordImageUseCaseImpl: RunningRecordImageUseCase {
  private let runningRepository: RunningRepository

  init(runningRepository: RunningRepository) {
    self.runningRepository = runningRepository
  }

  public func generateMapImage(for record: RunningRecord?) -> Single<UIImage> {
    return Single.create { single in
      guard let record = record else {
        single(.failure(NSError(domain: "ImageGenerationError", code: 0, userInfo: nil)))
        return Disposables.create()
      }
      let mapView = NMFMapView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))

      let points = record.runningPoints.map {
        NMGLatLng(lat: $0.location.lat, lng: $0.location.lon)
      }

      let polyline = NMFPolylineOverlay(points)
      polyline?.width = 8
      polyline?.color = .systemBlue
      polyline?.mapView = mapView

      let bounds = NMGLatLngBounds(latLngs: points)
      let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 50)
      mapView.moveCamera(cameraUpdate)

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        if let image = mapView.asImage() {
          single(.success(image))
        } else {
          single(.failure(NSError(domain: "ImageGenerationError", code: 0, userInfo: nil)))
        }
      }

      return Disposables.create()
    }
  }

  public func uploadImage(_ image: UIImage, recordId: Int) -> Single<String?> {
    return runningRepository.saveRunningRecordImage(recordId: recordId, image: image)
  }
}

extension UIView {
  func asImage() -> UIImage? {
    let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
    return renderer.image { context in
      self.layer.render(in: context.cgContext)
    }
  }
}
