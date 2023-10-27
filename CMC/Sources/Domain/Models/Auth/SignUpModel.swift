//
//  SignUpModel.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {
	let userId: Int
	let accessToken: String
	let refreshToken: String
}

