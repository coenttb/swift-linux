// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-linux",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: "Linux Primitives",
            targets: ["Linux Primitives"]
        ),
        .library(
            name: "Linux Kernel",
            targets: ["Linux Kernel"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-kernel-primitives"),
        .package(path: "../swift-posix"),
        .package(url: "https://github.com/swift-standards/swift-standards.git", from: "0.29.0")
    ],
    targets: [
        .target(
            name: "Linux Primitives",
            dependencies: []
        ),
        .target(
            name: "CLinuxKernelShim",
            dependencies: []
        ),
        .target(
            name: "Linux Kernel",
            dependencies: [
                .target(name: "Linux Primitives"),
                .product(name: "Kernel Primitives", package: "swift-kernel-primitives"),
                .product(name: "POSIX Kernel", package: "swift-posix"),
                .target(name: "CLinuxKernelShim"),
            ]
        ),
        .testTarget(
            name: "Linux Kernel Tests",
            dependencies: [
                "Linux Kernel",
                .product(name: "Kernel Primitives Test Support", package: "swift-kernel-primitives"),
                .product(name: "StandardsTestSupport", package: "swift-standards")
            ],
            path: "Tests/Linux Kernel Tests"
        ),
    ]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
