//
//  EmailDupDTO.swift
//  CMC
//
//  Created by Siri on 11/7/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - EmailDupDTO
struct EmailDupDTO: Codable {
	let isSuccess: Bool
	let code, message: String
	let result: EmailDupResponse
	
	struct EmailDupResponse: Codable {
		let message: String
	}
	
	func toDomain() -> EmailDupModel {
		return EmailDupModel(
			message: result.message
		)
	}
}
