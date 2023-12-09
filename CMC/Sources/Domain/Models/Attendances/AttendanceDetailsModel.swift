//
//  AttendanceDetailsModel.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

struct AttendanceDetailsModel: Codable {
	let week: Int
	let firstHour: String
	let secondHour: String
	let isOffline: Bool
	let enable: Bool
	let date: String
}
