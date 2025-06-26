import ProjectDescription

let project = Project(
  name: "Presentation",
  targets: [
    .target(
      name: "Presentation",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Presentation",
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
        .external(name: "SnapKit"),
        .external(name: "Then"),
        
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
