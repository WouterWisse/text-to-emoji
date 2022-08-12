// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "text-to-emoji",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "TextToEmoji",
            targets: ["TextToEmoji"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TextToEmoji",
            dependencies: []),
        .testTarget(
            name: "TextToEmojiTests",
            dependencies: ["TextToEmoji"]),
    ]
)
