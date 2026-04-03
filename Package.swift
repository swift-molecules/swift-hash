// swift-tools-version: 6.3

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
        .package(path: "../swift-equation-primitives"),
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-property-primitives"),
        .package(path: "../swift-identity-primitives"),
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
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Identity Primitives", package: "swift-identity-primitives"),
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
                .product(name: "Identity Primitives Test Support", package: "swift-identity-primitives"),
            ],
            path: "Tests/Support"
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
