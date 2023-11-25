//
//  ResettingPasswordBody.swift
//  CMC
//
//  Created by Siri on 11/25/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - ResettingPasswordBody
struct ResettingPasswordBody: Codable {
	let email: String
	let password: String
}
