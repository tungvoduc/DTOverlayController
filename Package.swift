// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DTOverlayController",
    products: [
        .library(name: "DTOverlayController", targets: ["DTOverlayController"]),
    ],
    targets: [
        .target(
            name: "DTOverlayController",
            path: "DTOverlayController/Classes"),
    ]
)
