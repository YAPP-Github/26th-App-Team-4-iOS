import ProjectDescription

let project = Project(
  name: "Data",
  targets: [
    .target(
      name: "Data",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Data",
      deploymentTargets: .iOS("15.6"),
      infoPlist: .default,
      sources: ["Data/Sources/**"],
      resources: ["Data/Resources/**"],
      dependencies: [
        .project(target: "Domain", path: "../Domain"),
        .project(target: "Core", path: "../Core"),
        
        .external(name: "Moya"),
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser")
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
