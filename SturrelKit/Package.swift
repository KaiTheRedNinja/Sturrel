// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SturrelKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SturrelTypes",
            targets: ["SturrelTypes"]),
        .library(
            name: "SturrelVocab",
            targets: ["SturrelVocab"]),
        .library(
            name: "SturrelQuiz",
            targets: ["SturrelQuiz"]),
        .library(
            name: "SturrelSearch",
            targets: ["SturrelSearch"]),
        .library(
            name: "SturrelThemes",
            targets: ["SturrelThemes"]),
        .library(
            name: "SturrelVocabUI",
            targets: ["SturrelVocabUI"]),
        .library(
            name: "SturrelQuizUI",
            targets: ["SturrelQuizUI"]),
        .library(
            name: "SturrelThemesUI",
            targets: ["SturrelThemesUI"]),
        .library(
            name: "SturrelSearchUI",
            targets: ["SturrelSearchUI"])
    ],
    targets: [
        // Base
        .target(
            name: "SturrelTypes",
            path: "Sources/Base/SturrelTypes"),
        .target(
            name: "PinYin",
            path: "Sources/Base/PinYin"),

        // Model
        .target(
            name: "SturrelVocab",
            dependencies: ["SturrelTypes"],
            path: "Sources/Model/SturrelVocab"),
        .target(
            name: "SturrelQuiz",
            dependencies: ["SturrelTypes", "PinYin"],
            path: "Sources/Model/SturrelQuiz"),
        .target(
            name: "SturrelSearch",
            dependencies: ["SturrelTypes", "PinYin", "SturrelVocab"],
            path: "Sources/Model/SturrelSearch"),
        .target(
            name: "SturrelThemes",
            dependencies: ["SturrelTypes"],
            path: "Sources/Model/SturrelThemes"),

        // UI
        .target(
            name: "SturrelVocabUI",
            dependencies: ["SturrelTypes", "SturrelVocab", "SturrelSearchUI", "SturrelQuizUI", "SturrelThemesUI"],
            path: "Sources/UI/SturrelVocabUI"),
        .target(
            name: "SturrelQuizUI",
            dependencies: ["SturrelTypes", "SturrelQuiz", "SturrelThemesUI"],
            path: "Sources/UI/SturrelQuizUI"),
        .target(
            name: "SturrelThemesUI",
            dependencies: ["SturrelTypes", "SturrelThemes"],
            path: "Sources/UI/SturrelThemesUI"),
        .target(
            name: "SturrelSearchUI",
            dependencies: ["SturrelTypes", "SturrelSearch", "SturrelThemesUI"],
            path: "Sources/UI/SturrelSearchUI"),

        // Tests
        .testTarget(
            name: "SturrelKitTests")
    ]
)
