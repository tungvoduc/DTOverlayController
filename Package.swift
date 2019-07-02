// swift-tools-version: 5.0

import PackageDescription

let package = Package(
    name: "DTOverlayController",
    products: [
        .library(
            name: "DTOverlayController",
            targets: ["DTOverlayController"]),
    ],
    dependencies: [
    
    ],
    targets: [
        .target(
            name: "DTOverlayController",
            dependencies: [],
            path: "DTOverlayController/Classes"),
    ]
)
