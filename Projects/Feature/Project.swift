import ProjectDescription

let project = Project(
  name: "Feature",
  targets: [
    .target(
      name: "Feature",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Feature",
      infoPlist: .default,
      sources: ["Feature/Sources/**"],
      resources: ["Feature/Resources/**"],
      dependencies: [
        .project(target: "Domain", path: "../Domain"),
        .project(target: "Core", path: "../Core"),
      ]
    ),
    .target(
      name: "FeatureTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.FeatureTests",
      infoPlist: .default,
      sources: ["Feature/Tests/**"],
      resources: [],
      dependencies: [.target(name: "Feature")]
    ),
  ]
)
