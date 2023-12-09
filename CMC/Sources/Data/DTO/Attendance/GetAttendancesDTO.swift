//
//  GetAttendancesDTO.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - AttendancesDTO
struct GetAttendancesDTO: Codable {
	let isSuccess: Bool
	let code:String
	let message: String
	let result: GetAttendancesResult
	
	func toDomain() -> (AttendanceStatusModel, [AttendanceDetailsModel]) {
		let attendanceStatusModel = AttendanceStatusModel(
			attendanceCount: result.attendanceStatus.attendanceCount,
			lateCount: result.attendanceStatus.lateCount,
			absentCount: result.attendanceStatus.absentCount
		)
		let attendanceDetailsModel = result.attandances.map {
			AttendanceDetailsModel(
				week: $0.week,
				firstHour: $0.firstHour,
				secondHour: $0.secondHour,
				isOffline: $0.isOffline,
				enable: $0.enable,
				date: $0.date
			)
		}
		return (attendanceStatusModel, attendanceDetailsModel)
	}
}

// MARK: - GetAttendancesResult
struct GetAttendancesResult: Codable {
		let attendanceStatus: AttendanceStatus
		let attandances: [Attandance]
}


// MARK: - AttendanceStatus -> 출석 전체 점수(?)
struct AttendanceStatus: Codable {
	let attendanceCount: Int
	let lateCount: Int
	let absentCount: Int
}


// MARK: - Attandance				-> 주차별 실제 출석 데이타
struct Attandance: Codable {
	let week: Int
	let firstHour: String
	let secondHour: String
	let isOffline: Bool
	let enable: Bool
	let date: String
}
