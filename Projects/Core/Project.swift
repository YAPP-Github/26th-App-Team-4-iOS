import ProjectDescription

let project = Project(
  name: "Core",
  targets: [
    .target(
      name: "Core",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Core",
      deploymentTargets: .iOS("15.6"),
      infoPlist: .default,
      sources: ["Core/Sources/**"],
      resources: ["Core/Resources/**"],
      dependencies: [
        .project(target: "Domain", path: "../Domain")
      ]
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
