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

        .library(name: "Hash", targets: ["Hash"]),
        .library(name: "Hash Value", targets: ["Hash Value"]),
        .library(name: "Hash Protocol", targets: ["Hash Protocol"]),
        .library(name: "Hash Tagged", targets: ["Hash Tagged"]),
        .library(
            name: "Hash Standard Library Integration",
            targets: ["Hash Standard Library Integration"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-equation.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [

        .target(name: "Hash", dependencies: []),

        .target(
            name: "Hash Value",
            dependencies: [
                .target(name: "Hash"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Hash Protocol",
            dependencies: [
                .target(name: "Hash Value"),
                .product(name: "Equation Protocol", package: "swift-equation"),
            ]
        ),
        .target(
            name: "Hash Tagged",
            dependencies: [
                .target(name: "Hash Protocol"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Hash Standard Library Integration",
            dependencies: [
                .target(name: "Hash Protocol"),
                .product(
                    name: "Equation Standard Library Integration",
                    package: "swift-equation"
                ),
            ]
        ),
        .testTarget(
            name: "Hash Tests",
            dependencies: [
                .target(name: "Hash"),
            ]
        ),
        .testTarget(
            name: "Hash Value Tests",
            dependencies: [
                .target(name: "Hash Value"),
            ]
        ),
        .testTarget(
            name: "Hash Protocol Tests",
            dependencies: [
                .target(name: "Hash Protocol"),
            ]
        ),
        .testTarget(
            name: "Hash Tagged Tests",
            dependencies: [
                .target(name: "Hash Tagged"),
                .target(name: "Hash Standard Library Integration"),
                .product(name: "Tagged Standard Library Integration", package: "swift-tagged"),
            ]
        ),
        .testTarget(
            name: "Hash Standard Library Integration Tests",
            dependencies: [
                .target(name: "Hash Standard Library Integration"),
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
