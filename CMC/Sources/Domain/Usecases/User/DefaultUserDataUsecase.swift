//
//  DefaultUserDataUsecase.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

final class DefaultUserDataUsecase: UserDataUsecase {
	
	init() {
	}
	
	func saveUserData(userData: GetUserModel) {
		UserDefaultManager.shared.save(userData.email, for: .email)
		UserDefaultManager.shared.save(userData.generation, for: .generation)
		UserDefaultManager.shared.save(userData.name, for: .name)
		UserDefaultManager.shared.save(userData.nickname, for: .nickname)
		UserDefaultManager.shared.save(userData.part, for: .part)
	}
	
	func saveNoneUserData() {
		UserDefaultManager.shared.save("--", for: .email)
		UserDefaultManager.shared.save("--", for: .generation)
		UserDefaultManager.shared.save(0, for: .name)
		UserDefaultManager.shared.save("--", for: .nickname)
		UserDefaultManager.shared.save("--", for: .part)
	}
	
}
