//
//  LaunchEndpoint.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum EmailEndpoint: Endpoint {
	
	case health
	
	var baseURL: URL? {
		return URL(string: "http://cmcapiserverdev-env.eba-au6k5x3x.ap-northeast-2.elasticbeanstalk.com")
	}
	
	var method: HTTPMethod {
		switch self {
		case .health:
			return .GET
			
		}
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
