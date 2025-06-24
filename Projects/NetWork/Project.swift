import ProjectDescription

let project = Project(
    name: "NetWork",
    targets: [
        .target(
            name: "NetWork",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.NetWork",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["NetWork/Sources/**"],
            resources: ["NetWork/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "NetWorkTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NetWorkTests",
            infoPlist: .default,
            sources: ["NetWork/Tests/**"],
            resources: [],
            dependencies: [.target(name: "NetWork")]
        ),
    ]
)
