//
//  AppDelegate.swift
//  CMC
//
//  Created by Siri on 2023/10/22.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
	var window: UIWindow?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
        
        FirebaseConfiguration.shared.setLoggerLevel(.min) /// Firebase 로그 최소화
        FirebaseApp.configure()
		return true
	}
}
