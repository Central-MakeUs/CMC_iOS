//
//  NotificationsDTO.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - NotificationsDTO
struct NotificationsDTO: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
	let result: NotificationsResult
	
	// MARK: - NotificationsResult
	struct NotificationsResult: Codable {
		let isLast: Bool
		let totalCnt: Int
		let contents: [NotificationsContent]
		
		// MARK: - Content
		struct NotificationsContent: Codable {
			let id: Int
			let week: Int
			let title: String
			let notionUrl: String
		}
	}
	
	func toModel() -> NotificationsModel {
		var contents: [NotificationsModel.NotificationsContentModel] = []
		for content in self.result.contents {
			contents.append(
				NotificationsModel.NotificationsContentModel(
					id: content.id,
					week: content.week,
					title: content.title,
					notionUrl: content.notionUrl
				)
			)
		}
		return NotificationsModel(
			isLast: self.result.isLast,
			totalCnt: self.result.totalCnt,
			contents: contents
		)
	}
}

