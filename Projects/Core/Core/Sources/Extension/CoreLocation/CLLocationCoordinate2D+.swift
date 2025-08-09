//
//  CLLocationCoordinate2D+.swift
//  Core
//
//  Created by dong eun shin on 8/9/25.
//

import CoreLocation

public extension CLLocationCoordinate2D {
  func distance(to other: CLLocationCoordinate2D) -> Double {
    let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let location2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
    return location1.distance(from: location2)
  }

  var location: CLLocation {
    CLLocation(latitude: self.latitude, longitude: self.longitude)
  }
}
