import ProjectDescription

let project = Project(
  name: "Presentation",
  targets: [
    .target(
      name: "Presentation",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Presentation",
      deploymentTargets: .iOS("15.6"),
      infoPlist: .default,
      sources: ["Presentation/Sources/**"],
      resources: ["Presentation/Resources/**"],
      dependencies: [
        .project(target: "Core", path: "../Core"),
        .project(target: "Domain", path: "../Domain"),

        .external(name: "Kingfisher"),
        .external(name: "ReactorKit"),
        .external(name: "RxGesture"),
        .external(name: "RxKeyboard"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser"),
        .external(name: "Swinject"),
        .external(name: "SwinjectAutoregistration"),
        .external(name: "NMapsMap"),
        .external(name: "Lottie")
      ]
    ),
    .target(
      name: "PresentationTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.PresentationTests",
      infoPlist: .default,
      sources: ["Presentation/Tests/**"],
      resources: [],
      dependencies: [.target(name: "Presentation")]
    ),
  ]
)
