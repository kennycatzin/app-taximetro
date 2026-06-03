// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "wakelock_plus", path: "../.packages/wakelock_plus-1.6.1"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-10.1.0"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "permission_handler_apple", path: "../.packages/permission_handler_apple-9.4.9"),
        .package(name: "geolocator_apple", path: "../.packages/geolocator_apple-2.3.13"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "wakelock-plus", package: "wakelock_plus"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "permission-handler-apple", package: "permission_handler_apple"),
                .product(name: "geolocator-apple", package: "geolocator_apple"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
