//
//  LaunchEndpoint.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum LaunchEndpoint: Endpoint {
	
	case health
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL)
	}
	
	var method: HTTPMethod {
		switch self {
		case .health:
			return .GET
			
		}
	}
	
	var headers: HTTPHeaders {
		return [
			"Content-Type": "application/json",
			"accept": "application/json"
		]
	}
	
	var path: String {
		switch self {
		case .health:
			return "/health"
		}
		
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .health:
			return nil
		}
	}
	
	
}
