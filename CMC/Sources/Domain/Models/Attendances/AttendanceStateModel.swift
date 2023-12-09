//
//  AttendanceStatusModel.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

struct AttendanceStatusModel: Codable {
	let attendanceCount: Int
	let lateCount: Int
	let absentCount: Int
}
