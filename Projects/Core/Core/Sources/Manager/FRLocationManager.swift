//
//  FRLocationManager.swift
//  Core
//
//  Created by JDeoks on 7/18/25.
//


import Foundation
import CoreLocation
import RxSwift
import RxRelay

public final class FRLocationManager: NSObject {

  public static let shared = FRLocationManager()

  private let manager = CLLocationManager()
  private let locationRelay = PublishRelay<CLLocation>()

  public var location: Observable<CLLocation> {
    return locationRelay.asObservable()
  }

  private override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }

  public func requestAuthorization() {
    manager.requestWhenInUseAuthorization()
  }

  public func startUpdatingLocation() {
    manager.startUpdatingLocation()
  }

  public func stopUpdatingLocation() {
    manager.stopUpdatingLocation()
  }
}

extension FRLocationManager: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.startUpdatingLocation()
    default:
      manager.stopUpdatingLocation()
    }
  }

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    locationRelay.accept(location)
  }
}
