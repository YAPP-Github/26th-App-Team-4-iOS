// swift-tools-version: 6.0

import PackageDescription


enum FRDependency: CaseIterable {
  
  case kingfisher
  case moya
  case reactorKit
  case rxGesture
  case rxKeyboard
  case rxSwift
  case rxCocoa
  case snapKit
  case then
  case kakaoSDK
  case swinject
  case swinjectAutoregistration

  
  var packageName: String {
    switch self {
    case .kingfisher: "Kingfisher"
    case .moya: "Moya"
    case .reactorKit: "ReactorKit"
    case .rxGesture: "RxGesture"
    case .rxKeyboard: "RxKeyboard"
    case .snapKit: "SnapKit"
    case .then: "Then"
    case .kakaoSDK: "KakaoOpenSDK"
    case .swinject: "Swinject"
    case .rxSwift: "RxSwift"
    case .rxCocoa: "RxCocoa"
    case .swinjectAutoregistration: "SwinjectAutoregistration"
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
    case .kakaoSDK: "https://github.com/kakao/kakao-ios-sdk"
    case .swinject: "https://github.com/Swinject/Swinject.git"
    case .rxSwift: "https://github.com/ReactiveX/RxSwift.git"
    case .rxCocoa: "https://github.com/ReactiveX/RxSwift.git"
    case .swinjectAutoregistration: "https://github.com/Swinject/SwinjectAutoregistration.git"
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
    case .kakaoSDK: "2.24.4"
    case .swinject: "2.8.0"
    case .rxSwift: "6.6.0"
    case .rxCocoa: "6.6.0"
    case .swinjectAutoregistration: "2.9.1"
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
