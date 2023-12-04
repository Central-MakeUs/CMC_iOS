//
//  NotificationsUsecase.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

protocol NotificationsUsecase {
	func getNotifications(query: NotificationsQuery) -> Single<NotificationsModel>
	func getLatestNotifications() -> Single<[LatestNotificationsModel]>
	func getAllNotifications() -> Single<[AllNotificationsModel]>
}
