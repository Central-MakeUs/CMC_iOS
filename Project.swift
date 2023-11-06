import ProjectDescription
import Foundation
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains CMC App target and CMC unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project


enum TargetType {
	case DesignSystem
	case App
}

protocol ProjectProfile {
	var projectName: String { get }
	
	func generateDependencies(targetName target: TargetType) -> [TargetDependency]
	func generateTarget() -> [Target]
	func generateAppConfigurations() -> Settings
}

class BaseProjectProfile: ProjectProfile{
	
	let projectName: String = "CMC"
	
	let infoPlist: [String: Plist.Value] = [
		"Base_Url" : "$(BASE_URL)",
		"ITSAppUsesNonExemptEncryption": false,
		"CFBundleShortVersionString": "1.0",
		"CFBundleVersion": "1",
		"CFBundleDevelopmentRegion": "ko_KR",
		"UILaunchStoryboardName": "LaunchScreen",
		"UIUserInterfaceStyle": "Light",
		"UIApplicationSceneManifest": [
				"UIApplicationSupportsMultipleScenes": false,
				"UISceneConfigurations": [
						"UIWindowSceneSessionRoleApplication": [
								[
										"UISceneConfigurationName": "Default Configuration",
										"UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
								],
						]
				]
		],
		"CFBundleIconName": "AppIcon",
		"UIAppFonts": [
			"Item 0": "Pretendard-Medium.otf",
			"Item 1": "Pretendard-Regular.otf",
			"Item 2": "Pretendard-SemiBold.otf",
			"Item 3": "Pretendard-Bold.otf"
		],
		"CFBundleURLTypes": [
			[
				"CFBundleURLName": "com.softsquared.cmc.ios"
			]
		],
		"NSAppTransportSecurity": [
			"NSAllowsArbitraryLoads": true
		]
	]
	
	func generateDependencies(targetName target: TargetType) -> [TargetDependency] {
		switch target{
		case .App:
			return commonDependencies() + [
				.target(name: "DesignSystem")
			]
		case .DesignSystem:
			return commonDependencies()
		}
	}
	
	func generateAppConfigurations() -> Settings {
		return Settings.settings(
			configurations: [
				.debug(name: "Dev", xcconfig: .relativeToCurrentFile("CMC/Resources/Configure/Dev.xcconfig")),
				.release(name: "Release", xcconfig: .relativeToCurrentFile("CMC/Resources/Configure/Release.xcconfig")),
			])
	}
	
	func generateTarget() -> [Target] {
		[
			Target(
				name: projectName,
				platform: .iOS,
				product: .app,
				bundleId: "com.softsquared.cmc.ios",
				deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
				infoPlist: .extendingDefault(with: infoPlist),
				sources: ["\(projectName)/Sources/**"],
				resources: "\(projectName)/Resources/**",
				dependencies: generateDependencies(targetName: .App),
				settings: generateAppConfigurations()
			),
			Target(
				name: "DesignSystem",
				platform: .iOS,
				product: .framework,
				bundleId: "com.softsquared.cmc.ios.DesignSystem",
				deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
				infoPlist: .default,
				sources: ["DesignSystem/Sources/**"],
				resources: "\(projectName)/Resources/**",
				dependencies: generateDependencies(targetName: .DesignSystem)
			)
		]
	}
	
}

let profile = BaseProjectProfile()

let project: Project = .init(
	name: profile.projectName,
	organizationName: "com.softsquared.cmc",
	settings: .settings(configurations: [
		.debug(name: "Dev"),
		.release(name: "Release")
	]),
	targets: profile.generateTarget()
)


extension BaseProjectProfile {
	fileprivate func commonDependencies() -> [TargetDependency] {
			return [
					.external(name: "RxSwift"),
					.external(name: "RxCocoa"),
					.external(name: "RxRelay"),
					.external(name: "RxGesture"),
					.external(name: "SnapKit")
			]
	}
}
