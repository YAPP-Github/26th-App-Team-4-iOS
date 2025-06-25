import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Domain",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Domain/Sources/**"],
            resources: ["Domain/Resources/**"],
            dependencies: [
              .project(target: "Core", path: "../Core"),

            ]
        ),
        .target(
            name: "DomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DomainTests",
            infoPlist: .default,
            sources: ["Domain/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Domain")]
        ),
    ]
)
