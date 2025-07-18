import ProjectDescription

let appName = "FITRUN"
let appTargetName = "FITRUN"
let testTargetName = "FITRUNTests"
let orgName = "com.yapp"

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
    "CFBundleURLTypes": [
      [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]
      ]
    ],
    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
    "LSApplicationQueriesSchemes": [
      "kakaokompassauth",
      "kakaolink"
    ],
    "NSAppTransportSecurity": [
      "NSAllowsArbitraryLoads": true
    ],
    "NSLocationAlwaysUsageDescription": "사용자의 위치를 받습니다.",
    "NSLocationWhenInUseUsageDescription": "앱 사용 중 위치를 받습니다."
  ]
)

let dependencies: [TargetDependency] = [
  // MARK: Module
  .project(target: "Core", path: "../Core"),
  .project(target: "Data", path: "../Data"),
  .project(target: "Domain", path: "../Domain"),
  .project(target: "Presentation", path: "../Presentation"),

  .external(name: "RxMoya"),
  .external(name: "Swinject"),
  .external(name: "NMapsMap")
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
      deploymentTargets: .iOS("15.6"),
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
