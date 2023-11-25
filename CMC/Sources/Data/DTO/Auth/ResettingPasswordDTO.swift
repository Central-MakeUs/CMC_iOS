//
//  ResettingPasswordDTO.swift
//  CMC
//
//  Created by Siri on 11/25/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

// MARK: - RessetingPasswordDTO
struct ResettingPasswordDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: String
	
	func toDomain() -> ResettingPasswordModel {
		return ResettingPasswordModel(
			message: result
		)
	}
}
