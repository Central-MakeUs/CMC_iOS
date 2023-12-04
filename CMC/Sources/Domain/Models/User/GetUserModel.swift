//
//  GetUserModel.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//


//MARK: - GetUserModel
struct GetUserModel: Codable {
	let name: String
	let email: String
	let nickname: String
	let generation: Int
	let part: String
}
