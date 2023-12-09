//
//  AttendancesEndpoint.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

enum AttendancesEndpoint: Endpoint {
	
	case getAttendances
	case postAttendances(body: PostAttendancesBody)
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL)
	}
	
	var method: HTTPMethod {
		switch self {
		case .getAttendances:
			return .GET
		case .postAttendances:
			return .POST
		}
	}
	
	var headers: HTTPHeaders {
		if let X_AUTH_TOKEN: String = UserDefaultManager.shared.load(for: .accessToken) {
			return [
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
		return "/attendances"
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .getAttendances:
			return .none
		case .postAttendances(let body):
			return .body(body)
		}
	}
	
}
