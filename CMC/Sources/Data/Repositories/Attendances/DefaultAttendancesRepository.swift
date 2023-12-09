//
//  DefaultAttendancesRepository.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAttendancesRepository: AttendancesRepository {
	
	private let networkService: NetworkService
	
	init() {
		self.networkService = DefaultNetworkService()
	}
	
	func getAttendances() -> Single<AttendancesDTO> {
		let endpoint = AttendancesEndpoint.getAttendances
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(AttendancesDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
}
