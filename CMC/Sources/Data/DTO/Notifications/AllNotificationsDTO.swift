//
//  AllNotificationsDTO.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - AllNotificationsDTO
struct AllNotificationsDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: [AllNotificationsResult]
	
	// MARK: - AllNotificationsResult
	struct AllNotificationsResult: Codable {
		let id: Int
		let week: Int
		let title: String
		let notionUrl: String
	}
	
	func toDomain() -> [AllNotificationsModel] {
		var allNotifications: [AllNotificationsModel] = []
		self.result.forEach { data in
			allNotifications.append(
				AllNotificationsModel(
					id: data.id,
					week: data.week,
					title: data.title,
					notionUrl: data.notionUrl
				)
			)
		}
		return allNotifications
	}
	
}


