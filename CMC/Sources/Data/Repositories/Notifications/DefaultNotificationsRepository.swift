//
//  DefaultNotificationsRepository.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultNotificationsRepository: NotificationsRepository {
	
	private let networkService: NetworkService
	
	init() {
		self.networkService = DefaultNetworkService()
	}
	
	func getNotifications(query: NotificationsQuery) -> Single<NotificationsDTO> {
		let endpoint = NotificationEndpoint.notifications(query: query)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(NotificationsDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func getLatestNotifications() -> Single<LatestNotificationsDTO> {
		let endpoint = NotificationEndpoint.notificationsLatest
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(LatestNotificationsDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func getAllNotifications() -> Single<AllNotificationsDTO> {
		let endpoint = NotificationEndpoint.notificationsAll
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(AllNotificationsDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
}
