// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TelegramColorPicker",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "TelegramColorPicker",
            targets: ["TelegramColorPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TelegramColorPicker",
            dependencies: [],
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "TelegramColorPickerTests",
            dependencies: ["TelegramColorPicker"],
            path: "Tests",
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
