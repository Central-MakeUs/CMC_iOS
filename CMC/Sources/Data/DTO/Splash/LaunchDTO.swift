//
//  LaunchDTO.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation


struct LaunchDTO: Codable {
	let message: String
	
	func toDomain() -> LaunchModel {
		return LaunchModel(
			message: message
		)
	}
}
