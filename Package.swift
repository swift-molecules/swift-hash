// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-hash-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        // MARK: - Namespace
        .library(
            name: "Hash Primitive",
            targets: ["Hash Primitive"]
        ),

        // MARK: - Sub-namespace targets
        .library(
            name: "Hash Value Primitives",
            targets: ["Hash Value Primitives"]
        ),
        .library(
            name: "Hash Protocol Primitives",
            targets: ["Hash Protocol Primitives"]
        ),
        .library(
            name: "Hash Tagged Primitives",
            targets: ["Hash Tagged Primitives"]
        ),

        // MARK: - StdLib Integration
        .library(
            name: "Hash Primitives Standard Library Integration",
            targets: ["Hash Primitives Standard Library Integration"]
        ),

        // MARK: - Umbrella
        .library(
            name: "Hash Primitives",
            targets: ["Hash Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Hash Primitives Test Support",
            targets: ["Hash Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-equation-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-property-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Namespace
        .target(
            name: "Hash Primitive",
            dependencies: []
        ),

        // MARK: - Sub-namespace targets (per [MOD-031])
        .target(
            name: "Hash Value Primitives",
            dependencies: [
                "Hash Primitive",
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Hash Protocol Primitives",
            dependencies: [
                "Hash Value Primitives",
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
            ]
        ),
        .target(
            name: "Hash Tagged Primitives",
            dependencies: [
                "Hash Protocol Primitives",
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),

        // MARK: - StdLib Integration
        .target(
            name: "Hash Primitives Standard Library Integration",
            dependencies: [
                "Hash Protocol Primitives",
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Hash Primitives",
            dependencies: [
                "Hash Primitive",
                "Hash Value Primitives",
                "Hash Protocol Primitives",
                "Hash Tagged Primitives",
                "Hash Primitives Standard Library Integration",
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Hash Primitives Test Support",
            dependencies: [
                "Hash Primitives",
                .product(name: "Tagged Primitives Test Support", package: "swift-tagged-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Hash Primitives Tests",
            dependencies: [
                "Hash Primitives",
                "Hash Primitives Test Support",
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
