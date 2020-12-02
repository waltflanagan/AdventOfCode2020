// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2020",
    products: [
        .executable(name: "dayOne", targets: ["DayOne"]),
        .executable(name: "dayTwo", targets: ["DayTwo"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DayOne",
            dependencies:[]),
        .target(
            name: "DayTwo",
            dependencies:[]),
//        .target(
//            name: "AOC2020",
//            dependencies:[.product(name: "ArgumentParser", package: "swift-argument-parser")]),
//        .testTarget(
//            name: "AOC2020Tests",
//            dependencies: ["AOC2020"]),
    ]
)
