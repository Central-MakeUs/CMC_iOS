//
//  NotificationEndpoint.swift
//  CMC
//
//  Created by Siri on 12/3/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

enum NotificationEndpoint: Endpoint {
	
	case notifications(query: NotificationsQuery)
	case notificationsLatest
	case notificationsAll
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL + "/notifications")
	}
	
	var method: HTTPMethod {
		switch self {
		case .notifications:
			return .GET
		case .notificationsLatest:
			return .GET
		case .notificationsAll:
			return .GET
		}
	}
	
	var headers: HTTPHeaders {
		if let X_AUTH_TOKEN: String = UserDefaultManager.shared.load(for: .accessToken) {
			return [
				"Content-Type": "application/json;charset=UTF-8",
				"accept": "application/json;charset=UTF-8",
				"X-AUTH-TOKEN": X_AUTH_TOKEN
			]
		} else {
			return [
				"Content-Type": "application/json;charset=UTF-8",
				"accept": "application/json;charset=UTF-8"
			]
		}
	}
	
	var path: String {
		switch self {
		case .notifications:
			return ""
		case .notificationsLatest:
			return "/latest"
		case .notificationsAll:
			return "/all"
		}
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .notifications(let query):
			return .query([
				"page": "\(query.page)",
				"size": "\(query.size)"
			])
		case .notificationsLatest:
			return .none
		case .notificationsAll:
			return .none
		}
	}
	
}
