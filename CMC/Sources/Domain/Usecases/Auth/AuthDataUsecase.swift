//
//  AuthDataUsecase.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

protocol AuthDataUsecase {
	func saveAuthData(signInModel: SignInModel)
	func deleteAuthData()
}
