//
//  Dependencies.swift
//  Config
//
//  Created by Siri on 2023/10/22.
//

import ProjectDescription

let spm = SwiftPackageManagerDependencies([
		.remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.6.0")),
		.remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMinor(from: "4.0.0")),
		.remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.6.0"))
		],
		baseSettings: .settings(configurations: [
								.debug(name: "DEV"),
								.release(name: "Release")
]))

let dependencies = Dependencies(
		swiftPackageManager: spm,
		platforms: [.iOS]
)

