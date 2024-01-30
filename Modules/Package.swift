// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "RijksAPI", targets: ["RijksAPI"]),
        .library(name: "Toolbox", targets: ["Toolbox"]),
        .library(name: "CommonUI", targets: ["CommonUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/vdka/SecretsManager.git", exact: "1.1.3")
    ],
    targets: [
        .target(
            name: "RijksAPI",
            dependencies: [
                "Toolbox"
            ],
            plugins: [
                .plugin(name: "SecretsManagerPlugin", package: "SecretsManager")
            ]),
        .testTarget(
            name: "APITests",
            dependencies: ["RijksAPI"]),
        .target(name: "CommonUI", dependencies: [
            "Toolbox"
        ]),
        .target(name: "Toolbox", dependencies: [])
    ])
