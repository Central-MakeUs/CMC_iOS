//
//  NotificationsModel.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

// MARK: - NotificationsModel
struct NotificationsModel: Codable {
	let isLast: Bool
	let totalCnt: Int
	let contents: [NotificationsContentModel]
	
	// MARK: - NotificationsContentModel
	struct NotificationsContentModel: Codable {
		let id: Int
		let week: Int
		let title: String
		let notionUrl: String
	}
}
