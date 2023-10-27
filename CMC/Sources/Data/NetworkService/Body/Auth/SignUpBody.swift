//
//  SignUpBody.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

// MARK: - SignUpBody
struct SignUpBody: Codable {
	let email: String
	let password: String
	let nickname: String
	let name: String
	let generation: Int
	let part: String
}
