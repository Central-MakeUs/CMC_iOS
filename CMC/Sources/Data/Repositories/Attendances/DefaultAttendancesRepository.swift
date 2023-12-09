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
	
	func getAttendances() -> Single<GetAttendancesDTO> {
		let endpoint = AttendancesEndpoint.getAttendances
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(GetAttendancesDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func postAttendances(body: PostAttendancesBody) -> Single<PostAttendancesDTO> {
		let endpoint = AttendancesEndpoint.postAttendances(body: body)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(PostAttendancesDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
}
