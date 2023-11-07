//
//  AuthEndpoint.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum AuthEndpoint: Endpoint {
	
	case signIn(body: SignInBody)
	case signUp(body: SignUpBody)
	case emailDup(query: EmailDupQuery)
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL + "/auth")
	}
	
	var method: HTTPMethod {
		switch self {
		case .signUp, .signIn:
			return .POST
		case .emailDup:
			return .GET
		}
	}
	
	var path: String {
		switch self {
		case .signUp:
			return "/signUp"
		case .signIn:
			return "/signIn"
		case .emailDup:
			return "/email"
		}
		
	}
	
	var parameters: HTTPRequestParameterType? {
		switch self {
		case .signUp(let body):
			return .body(body)
		case .signIn(let body):
			return .body(body)
		case .emailDup(let query):
			return .query([
				"email": query.email
			])
		}
	}
	
}
