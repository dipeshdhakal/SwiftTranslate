// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(

    name: "SwiftTranslate",
    platforms: [
        .macOS(.v12),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftTranslate",
            targets: ["SwiftTranslate"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftTranslate"
        ),
        .testTarget(
            name: "SwiftTranslateTests",
            dependencies: ["SwiftTranslate"]
        ),
    ]
)
