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
            sources: ["\(appName)/Sources/**"],
            resources: ["\(appName)/Resources/**"],
            dependencies: []
        ),
        .target(
            name: testTargetName,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(orgName).\(testTargetName)",
            infoPlist: .default,
            sources: ["\(appName)/Tests/**"],
            resources: [],
            dependencies: [.target(name: appName)]
        ),
    ]
)
