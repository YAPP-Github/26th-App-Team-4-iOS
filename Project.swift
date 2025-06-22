import ProjectDescription

let project = Project(
    name: "FITRUN",
    targets: [
        .target(
            name: "FITRUN",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.FITRUN",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["FITRUN/Sources/**"],
            resources: ["FITRUN/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "FITRUNTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.FITRUNTests",
            infoPlist: .default,
            sources: ["FITRUN/Tests/**"],
            resources: [],
            dependencies: [.target(name: "FITRUN")]
        ),
    ]
)
