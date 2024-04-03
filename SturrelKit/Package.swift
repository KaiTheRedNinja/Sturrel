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
//        .library(
//            name: "SturrelUIInterface",
//            targets: ["SturrelUIInterface"]),
//        .library(
//            name: "SturrelUI",
//            targets: ["SturrelUI"]),
//        .library(
//            name: "SturrelUIViewModel",
//            targets: ["SturrelUIViewModel"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SturrelTypes",
            path: "Sources/Base/SturrelTypes"),
        .target(
            name: "PinYin",
            path: "Sources/Base/PinYin"),
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
//        .target(
//            name: "SturrelUIInterface",
//            dependencies: ["SturrelTypes"], 
//            path: "UI/SturrelUIInterface"),
//        .target(
//            name: "SturrelUI",
//            dependencies: ["SturrelTypes", "SturrelUIInterface"], 
//            path: "UI/SturrelUI"),
//        .target(
//            name: "SturrelUIViewModels",
//            dependencies: ["SturrelTypes", "SturrelUIInterface"], 
//            path: "UI/SturrelUIViewModels"),
        .testTarget(
            name: "SturrelKitTests")
    ]
)
