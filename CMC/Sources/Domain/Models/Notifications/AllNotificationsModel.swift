//
//  AllNotificationsModel.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

// MARK: - AllNotificationsModel
struct AllNotificationsModel: Codable {
	let id: Int
	let week: Int
	let title: String
	let notionUrl: String
}
