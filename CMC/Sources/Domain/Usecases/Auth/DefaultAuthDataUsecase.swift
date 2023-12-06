//
//  DefaultAuthDataUsecase.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

final class DefaultAuthDataUsecase: AuthDataUsecase {
	
	init() {
	}
	
	func saveAuthData(signInModel: SignInModel) {
		UserDefaultManager.shared.save(signInModel.accessToken, for: .accessToken)
		UserDefaultManager.shared.save(signInModel.refreshToken, for: .refreshToken)
	}
	
}
