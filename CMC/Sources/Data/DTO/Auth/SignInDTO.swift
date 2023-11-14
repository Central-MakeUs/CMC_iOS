//
//  SignInDTO.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

// MARK: - SignInDTO
struct SignInDTO: Codable {
	let isSuccess: Bool
	let code, message: String
	let result: SignInResponse
	
	struct SignInResponse: Codable {
		let userId: Int
		let accessToken: String
		let refreshToken: String
	}
	
	func toDomain() -> SignInModel {
		return SignInModel(
			userId: result.userId,
			accessToken: result.accessToken,
			refreshToken: result.refreshToken
		)
	}
}
