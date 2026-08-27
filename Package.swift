// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-hash",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Hash",
            targets: ["Hash"]
        ),
        .library(
            name: "Hash Standard Library Integration",
            targets: ["Hash Standard Library Integration"]
        ),
        .library(
            name: "Hash Apple Foundation Integration",
            targets: ["Hash Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Hash",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Hash Standard Library Integration",
            dependencies: ["Hash"]
        ),
        .target(
            name: "Hash Apple Foundation Integration",
            dependencies: [
                "Hash",
                "Hash Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Hash Tests",
            dependencies: [
                "Hash",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
