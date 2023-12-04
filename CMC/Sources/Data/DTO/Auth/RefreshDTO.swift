//
//  RefreshDTO.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - RefreshDTO
struct RefreshDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: RefreshResult
	
	struct RefreshResult: Codable {
		let accessToken: String
	}
	
	func toDomain() -> RefreshModel {
		return RefreshModel(
			accessToken: result.accessToken
		)
	}
}
