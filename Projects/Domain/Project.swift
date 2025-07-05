import ProjectDescription

let project = Project(
  name: "Domain",
  targets: [
    .target(
      name: "Domain",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Domain",
      deploymentTargets: .iOS("15.6"),
      infoPlist: .default,
      sources: ["Domain/Sources/**"],
      resources: ["Domain/Resources/**"],
      dependencies: []
    ),
    .target(
      name: "DomainTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.DomainTests",
      infoPlist: .default,
      sources: ["Domain/Tests/**"],
      resources: [],
      dependencies: [.target(name: "Domain")]
    ),
  ]
)
