import ProjectDescription

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Data",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Data/Sources/**"],
            resources: ["Data/Resources/**"],
            dependencies: []
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
