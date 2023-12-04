//
//  GetUsersDTO.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

// MARK: - GetUsersDTO
struct GetUsersDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: GetUsersResult
	
	// MARK: - GetUsersResult
	struct GetUsersResult: Codable {
		let name: String
		let email: String
		let nickname: String
		let generation: Int
		let part: String
	}
	
	func toDomain() -> GetUserModel {
		return GetUserModel(
			name: self.result.name,
			email: self.result.email,
			nickname: self.result.nickname,
			generation: self.result.generation,
			part: self.result.part
		)
	}
	
}

