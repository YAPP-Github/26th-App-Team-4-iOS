import ProjectDescription

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.Presentation",
            infoPlist: .default,
            sources: ["Presentation/Sources/**"],
            resources: ["Presentation/Resources/**"],
            dependencies: [
              .project(target: "Core", path: "../Core"),
              .project(target: "Domain", path: "../Domain"),
            ]
        ),
        .target(
            name: "PresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.PresentationTests",
            infoPlist: .default,
            sources: ["Presentation/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Presentation")]
        ),
    ]
)
