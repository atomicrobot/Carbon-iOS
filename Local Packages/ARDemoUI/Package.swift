// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARDemoUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ARDemoUI",
            targets: ["ARDemoUI"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "ARDemoUI",
            dependencies: []),
        .testTarget(
            name: "ARDemoUITests",
            dependencies: ["ARDemoUI"]),
    ]
)
