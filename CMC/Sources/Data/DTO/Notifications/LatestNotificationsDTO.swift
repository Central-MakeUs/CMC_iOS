//
//  LatestNotificationsDTO.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - LatestNotificationsDTO
struct LatestNotificationsDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: [LatestNotificationsResult]
	
	// MARK: - LatestNotificationsResult
	struct LatestNotificationsResult: Codable {
		let id: Int
		let week: Int
		let title: String
		let notionUrl: String
	}
	
	func toDomain() -> [LatestNotificationsModel] {
		var latestNotifications: [LatestNotificationsModel] = []
		self.result.forEach { data in
			latestNotifications.append(
				LatestNotificationsModel(
					id: data.id,
					week: data.week,
					title: data.title,
					notionUrl: data.notionUrl
				)
			)
		}
		return latestNotifications
	}
}

