//
//  DefaultUserRepository.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
	
	private let networkService: NetworkService
	
	init() {
		self.networkService = DefaultNetworkService()
	}
	
	func getUser() -> Single<GetUsersDTO> {
		let endpoint = UserEndpoint.getUser
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(GetUsersDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func deleteUser() -> Single<DeleteUsersDTO> {
		let endpoint = UserEndpoint.getUser
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(DeleteUsersDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
}
