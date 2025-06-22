// swift-tools-version: 6.0

import PackageDescription


enum FRDependency: CaseIterable {
  
  case kingfisher
  case moya
  case reactorKit
  case rxGesture
  case rxKeyboard
  case snapKit
  case then

  
  var packageName: String {
    switch self {
    case .kingfisher: "Kingfisher"
    case .moya: "Moya"
    case .reactorKit: "ReactorKit"
    case .rxGesture: "RxGesture"
    case .rxKeyboard: "RxKeyboard"
    case .snapKit: "SnapKit"
    case .then: "Then"
    }
  }
  
  var packageURL: String {
    switch self {
    case .kingfisher: "https://github.com/onevcat/Kingfisher.git"
    case .moya: "https://github.com/Moya/Moya.git"
    case .reactorKit: "https://github.com/ReactorKit/ReactorKit.git"
    case .rxGesture: "https://github.com/RxSwiftCommunity/RxGesture.git"
    case .rxKeyboard: "https://github.com/RxSwiftCommunity/RxKeyboard.git"
    case .snapKit: "https://github.com/SnapKit/SnapKit.git"
    case .then: "https://github.com/devxoul/Then.git"
    }
  }
  
  var version: String {
    switch self {
    case .kingfisher: "8.3.2"
    case .moya: "15.0.3"
    case .reactorKit: "3.2.0"
    case .rxGesture: "4.0.4"
    case .rxKeyboard: "2.0.1"
    case .snapKit: "5.7.1"
    case .then: "3.0.0"
    }
  }
}


#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  productTypes: Dictionary(
    uniqueKeysWithValues: FRDependency.allCases.map {
      ($0.packageName, .staticFramework)
    }
  )
)
#endif

let package = Package(
  name: "FITRUN",
  dependencies: FRDependency.allCases.map {
    .package(url: $0.packageURL, .upToNextMajor(from: .init(stringLiteral: $0.version)))
  }
)
