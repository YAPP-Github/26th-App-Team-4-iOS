import ProjectDescription

let appName = "FITRUN"
let appTargetName = "FITRUN"
let testTargetName = "FITRUNTests"
let orgName = "com.deok"

let appTargetInfoPlist: InfoPlist = .extendingDefault(
  with: [
    "UILaunchStoryboardName": "LaunchScreen.storyboard",
    "UIApplicationSceneManifest": [
      "UIApplicationSupportsMultipleScenes": true,
      "UISceneConfigurations": [
        "UIWindowSceneSessionRoleApplication": [
          [
            "UISceneConfigurationName": "Default Configuration",
            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
          ],
        ]
      ]
    ],
  ]
)

let dependencies: [TargetDependency] = [
  // MARK: Module
  .project(target: "Core", path: "../Core"),
  .project(target: "Data", path: "../Data"),
  .project(target: "Domain", path: "../Domain"),
  .project(target: "Presentation", path: "../Presentation"),
  
  // MARK: External
  //  .external(name: "Kingfisher"),
  //  .external(name: "Moya"),
  //  .external(name: "ReactorKit"),
  //  .external(name: "RxGesture"),
  //  .external(name: "RxKeyboard"),
  //  .external(name: "SnapKit"),
  //  .external(name: "Then"),
]


let project = Project(
  name: appName,
  organizationName: orgName,
  targets: [
    .target(
      name: appTargetName,
      destinations: .iOS,
      product: .app,
      bundleId: "\(orgName).\(appTargetName)",
      infoPlist: appTargetInfoPlist,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: dependencies,
      settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig"),
        .release(name: "Release", xcconfig: "Configs/Release.xcconfig")
      ])
    ),
    .target(
      name: testTargetName,
      destinations: .iOS,
      product: .unitTests,
      bundleId: "\(orgName).\(testTargetName)",
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [.target(name: appName)]
    ),
  ]
)
