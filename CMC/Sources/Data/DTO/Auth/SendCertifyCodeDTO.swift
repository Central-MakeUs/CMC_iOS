//
//  SendCertifyCodeDTO.swift
//  CMC
//
//  Created by Siri on 11/25/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - SendCertifyCodeDTO
struct SendCertifyCodeDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: String
	
	func toDomain() -> SendCertifyCodeModel {
		return SendCertifyCodeModel(
			message: result
		)
	}
}
