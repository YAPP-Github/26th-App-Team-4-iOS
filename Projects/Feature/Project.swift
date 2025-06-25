import ProjectDescription

let project = Project(
  name: "Feature",
  targets: [
    .target(
      name: "Feature",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Feature",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["Feature/Sources/**"],
      resources: ["Feature/Resources/**"],
      dependencies: [
        .project(target: "Service", path: "../Service"),
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
