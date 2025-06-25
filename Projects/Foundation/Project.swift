import ProjectDescription

let project = Project(
    name: "Foundation",
    targets: [
        .target(
            name: "Foundation",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Foundation",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Foundation/Sources/**"],
            resources: ["Foundation/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "FoundationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.FoundationTests",
            infoPlist: .default,
            sources: ["Foundation/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Foundation")]
        ),
    ]
)
