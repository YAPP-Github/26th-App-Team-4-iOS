import ProjectDescription


let dependencies: [TargetDependency] = [
    .external(name: "Kingfisher"),
    .external(name: "Moya"),
    .external(name: "ReactorKit"),
    .external(name: "RxGesture"),
    .external(name: "RxKeyboard"),
    .external(name: "SnapKit"),
    .external(name: "Then"),
]

let project = Project(
  name: "Core",
  targets: [
    .target(
      name: "Core",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Core",
      infoPlist: .default,
      sources: ["Core/Sources/**"],
      resources: ["Core/Resources/**"],
      dependencies: dependencies
    ),
    .target(
      name: "CoreTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.CoreTests",
      infoPlist: .default,
      sources: ["Core/Tests/**"],
      resources: [],
      dependencies: [.target(name: "Core")]
    ),
  ]
)
