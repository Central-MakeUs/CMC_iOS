//
//  NotificationsRepository.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

protocol NotificationsRepository {
	func getNotifications(query: NotificationsQuery) -> Single<NotificationsDTO>
	func getLatestNotifications() -> Single<LatestNotificationsDTO>
	func getAllNotifications() -> Single<AllNotificationsDTO>
}

