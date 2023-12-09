//
//  AttendancesRepository.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

protocol AttendancesRepository {
	func getAttendances() -> Single<GetAttendancesDTO>
	func postAttendances(body: PostAttendancesBody) -> Single<PostAttendancesDTO>
}
