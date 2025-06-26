import ProjectDescription

let project = Project(
  name: "Data",
  targets: [
    .target(
      name: "Data",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Data",
      infoPlist: .default,
      sources: ["Data/Sources/**"],
      resources: ["Data/Resources/**"],
      dependencies: [
        .project(target: "Domain", path: "../Domain"),
        .project(target: "Core", path: "../Core"),
        
        .external(name: "Moya"),
      ]
    ),
    .target(
      name: "DataTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.DataTests",
      infoPlist: .default,
      sources: ["Data/Tests/**"],
      resources: [],
      dependencies: [.target(name: "Data")]
    ),
  ]
)
