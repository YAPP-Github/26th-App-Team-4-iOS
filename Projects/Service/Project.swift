import ProjectDescription

let project = Project(
    name: "Service",
    targets: [
        .target(
            name: "Service",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Service",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Service/Sources/**"],
            resources: ["Service/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "ServiceTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ServiceTests",
            infoPlist: .default,
            sources: ["Service/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Service")]
        ),
    ]
)
