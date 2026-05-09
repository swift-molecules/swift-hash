// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-hash-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Hash Primitives",
            targets: ["Hash Primitives"]
        ),
        .library(
            name: "Hash Primitives Core",
            targets: ["Hash Primitives Core"]
        ),
        .library(
            name: "Hash Primitives Standard Library Integration",
            targets: ["Hash Primitives Standard Library Integration"]
        ),
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
        .target(
            name: "Hash Primitives",
            dependencies: [
                "Hash Primitives Core",
                "Hash Primitives Standard Library Integration"
            ]
        ),
        .target(
            name: "Hash Primitives Core",
            dependencies: [
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Hash Primitives Standard Library Integration",
            dependencies: [
                "Hash Primitives Core"
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
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
