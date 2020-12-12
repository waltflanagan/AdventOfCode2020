// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2020",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "dayOne", targets: ["DayOne"]),
        .executable(name: "dayTwo", targets: ["DayTwo"]),
        .executable(name: "dayThree", targets: ["DayThree"]),
        .executable(name: "dayFour", targets: ["DayFour"]),
        .executable(name: "dayFive", targets: ["DayFive"]),
        .executable(name: "daySix", targets: ["DaySix"]),
        .executable(name: "daySeven", targets: ["DaySeven"]),
        .executable(name: "dayEight", targets: ["DayEight"]),
        .executable(name: "dayNine", targets: ["DayNine"]),
        .executable(name: "dayTen", targets: ["DayTen"]),
        .executable(name: "dayEleven", targets: ["DayEleven"]),
        .executable(name: "DayTwelve", targets: ["DayTwelve"]),
        
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Shared",
            dependencies:[]),
        .target(
            name: "DayOne",
            dependencies:["Shared"]),
        .target(
            name: "DayTwo",
            dependencies:[]),
        .target(
            name: "DayThree",
            dependencies:["Shared"]),
        .target(
            name: "DayFour",
            dependencies:["Shared"]),
        .target(
            name: "DayFive",
            dependencies:[]),
        .target(
            name: "DaySix",
            dependencies:[]),
        .target(
            name: "DaySeven",
            dependencies:["Shared"]),
        .target(
            name: "DayEight",
            dependencies:["Shared"]),
        .target(
            name: "DayNine",
            dependencies:["Shared"]),
        .target(
            name: "DayTen",
            dependencies:["Shared"]),
        .target(
            name: "DayEleven",
            dependencies:["Shared"]),
        .target(
            name: "DayTwelve",
            dependencies:["Shared"]),
        .target(
            name: "AOC2020",
            dependencies:[]),
//        .testTarget(
//            name: "AOC2020Tests",
//            dependencies: ["AOC2020"]),
    ]
)
