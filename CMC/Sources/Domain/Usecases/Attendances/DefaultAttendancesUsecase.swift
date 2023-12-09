//
//  DefaultAttendancesUsecase.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAttendancesUsecase: AttendancesUsecase {
	
	private let attendancesRepository: AttendancesRepository
	
	init(attendancesRepository: AttendancesRepository) {
		self.attendancesRepository = attendancesRepository
	}
	
	func getAttendances() -> Single<(AttendanceStatusModel,[AttendanceDetailsModel])> {
		return attendancesRepository.getAttendances()
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func postAttendances(body: PostAttendancesBody) -> Single<AttendanceResultModel> {
		return attendancesRepository.postAttendances(body: body)
			.map { dto in
				return dto.toDomain()
			}
	}
	
}
