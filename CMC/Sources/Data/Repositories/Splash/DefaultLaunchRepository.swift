//
//  DefaultLaunchRepository.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultLaunchRepository: LaunchRepository {
	
	private let networkService: NetworkService
	
	init() {
		self.networkService = DefaultNetworkService()
	}
	
	func health() -> Single<LaunchDTO> {
		let endpoint = LaunchEndpoint.health
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(LaunchDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
}
