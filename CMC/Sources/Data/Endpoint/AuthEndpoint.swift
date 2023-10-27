//
//  AuthEndpoint.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum AuthEndpoint: Endpoint {
	
	case signIn(body: SignInBody), signUp(body: SignUpBody)
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL + "/auth")
	}
	
	var method: HTTPMethod {
		switch self {
		case .signUp, .signIn:
			return .POST
		}
	}
	
	var path: String {
		switch self {
		case .signUp:
			return "/signUp"
		case .signIn:
			return "/signIn"
		}
		
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .signUp(let body):
			return .body(body)
		case .signIn(let body):
			return .body(body)
		}
	}
	
}
