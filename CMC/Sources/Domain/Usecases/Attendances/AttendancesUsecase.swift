//
//  AttendancesUsecase.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

protocol AttendancesUsecase {
	func getAttendances() -> Single<(AttendanceStatusModel,[AttendanceDetailsModel])>
	func postAttendances(body: PostAttendancesBody) -> Single<AttendanceResultModel>
}
