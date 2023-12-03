//
//  UserEndpoint.swift
//  CMC
//
//  Created by Siri on 12/3/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

enum UserEndpoint: Endpoint {
	
	case getUser
	case deleteUser
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL + "/users")
	}
	
	var method: HTTPMethod {
		switch self {
		case .getUser:
			return .GET
		case .deleteUser:
			return .DELETE
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
		return ""
	}
	
	var parameters: HTTPRequestParameterType? {
		return .none
	}
	
}
