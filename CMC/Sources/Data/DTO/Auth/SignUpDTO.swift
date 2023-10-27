//
//  SignUpDTO.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

// MARK: - SignUpDTO
struct SignUpDTO: Codable {
	let isSuccess: Bool
	let code, message: String
	let result: SignUpResponse
	
	struct SignUpResponse: Codable {
		let userId: Int
		let accessToken: String
		let refreshToken: String
	}
	
	func toDomain() -> SignUpModel {
		return SignUpModel(
			userId: result.userId,
			accessToken: result.accessToken,
			refreshToken: result.refreshToken
		)
	}
}
