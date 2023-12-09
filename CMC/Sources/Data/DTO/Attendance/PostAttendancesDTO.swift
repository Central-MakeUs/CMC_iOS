//
//  PostAttendancesDTO.swift
//  CMC
//
//  Created by Siri on 12/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - PostAttendancesDTO
struct PostAttendancesDTO: Codable {
	let isSuccess: Bool
	let code:String
	let message: String
	let result: String
	
	func toDomain() -> AttendanceResultModel {
		return AttendanceResultModel(message: result)
	}
}

