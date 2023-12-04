//
//  DeleteUsersDTO.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

// MARK: - DeleteUsersDTO
struct DeleteUsersDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: String
	
	func toDomain() -> DeleteUserModel {
		return DeleteUserModel(message: result)
	}
}
