//
//  UserDefaultManager.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

class UserDefaultManager {
	
	static let shared = UserDefaultManager()
	private let userDefaults = UserDefaults.standard
	
	/// 요기에는 내 맘대로 추가 해야징~
	enum Key: String {
		case jwtToken
	}
	
	func save<T>(_ value: T, for key: Key) {
		userDefaults.set(value, forKey: key.rawValue)
	}
	
	func load<T>(for key: Key) -> T? {
		return userDefaults.object(forKey: key.rawValue) as? T
	}
	
	func delete(for key: Key) {
		userDefaults.removeObject(forKey: key.rawValue)
	}
}
