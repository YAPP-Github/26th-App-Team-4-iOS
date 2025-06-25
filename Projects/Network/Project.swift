import ProjectDescription

let project = Project(
    name: "Network",
    targets: [
        .target(
            name: "Network",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Network",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Network/Sources/**"],
            resources: ["Network/Resources/**"],
            dependencies: [
              .project(target: "Core", path: "../Core"),
            ]
        ),
        .target(
            name: "NetworkTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NetworkTests",
            infoPlist: .default,
            sources: ["Network/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Network")]
        ),
    ]
)
