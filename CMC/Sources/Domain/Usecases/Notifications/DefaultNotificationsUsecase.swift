//
//  DefaultNotificationsUsecase.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultNotificationsUsecase: NotificationsUsecase {
	
	private let notificationsRepository: NotificationsRepository
	
	init(notificationsRepository: NotificationsRepository) {
		self.notificationsRepository = notificationsRepository
	}
	
	func getNotifications(query: NotificationsQuery) -> Single<NotificationsModel> {
		return notificationsRepository.getNotifications(query: query)
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func getLatestNotifications() -> Single<[LatestNotificationsModel]> {
		return notificationsRepository.getLatestNotifications()
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func getAllNotifications() -> Single<[AllNotificationsModel]> {
		return notificationsRepository.getAllNotifications()
			.map { dto in
				return dto.toDomain()
			}
	}
	
}
