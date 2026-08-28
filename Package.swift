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
            name: "Hash Primitive",
            targets: ["Hash Primitive"]
        ),

        .library(
            name: "Hash Value",
            targets: ["Hash Value"]
        ),
        .library(
            name: "Hash Protocol",
            targets: ["Hash Protocol"]
        ),
        .library(
            name: "Hash Tagged",
            targets: ["Hash Tagged"]
        ),

        .library(
            name: "Hash Standard Library Integration",
            targets: ["Hash Standard Library Integration"]
        ),

        .library(
            name: "Hash",
            targets: ["Hash"]
        ),

        .library(
            name: "Hash Test Support",
            targets: ["Hash Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-equation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-property.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-tagged.git", branch: "main"),
    ],
    targets: [

        .target(
            name: "Hash Primitive",
            dependencies: []
        ),

        .target(
            name: "Hash Value",
            dependencies: [
                "Hash Primitive",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Hash Protocol",
            dependencies: [
                "Hash Value",
                .product(name: "Equation", package: "swift-equation"),
            ]
        ),
        .target(
            name: "Hash Tagged",
            dependencies: [
                "Hash Protocol",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Hash Standard Library Integration",
            dependencies: [
                "Hash Protocol",
            ]
        ),

        .target(
            name: "Hash",
            dependencies: [
                "Hash Primitive",
                "Hash Value",
                "Hash Protocol",
                "Hash Tagged",
                "Hash Standard Library Integration",
                .product(name: "Property", package: "swift-property"),
                .product(name: "Equation", package: "swift-equation"),
            ]
        ),

        .target(
            name: "Hash Test Support",
            dependencies: [
                "Hash",
                .product(name: "Tagged Test Support", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Hash Tests",
            dependencies: [
                "Hash",
                "Hash Test Support",
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
