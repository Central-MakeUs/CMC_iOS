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
	case sendCertifyCode(query: SendCertifyCodeQuery)
	case confirmCertifyCode(body: ConfirmCertifyCodeBody)
	case resettingPassword(body: ResettingPasswordBody)
	
	var baseURL: URL? {
		return URL(string: Xcconfig.BASE_URL + "/auth")
	}
	
	var method: HTTPMethod {
		switch self {
		case .signUp, .signIn, .confirmCertifyCode:
			return .POST
		case .emailDup, .sendCertifyCode:
			return .GET
		case .resettingPassword:
			return .PATCH
		}
	}
	
	var headers: HTTPHeaders {
		return [
			"Content-Type": "application/json;charset=UTF-8",
			"accept": "application/json;charset=UTF-8"
		]
	}
	
	var path: String {
		switch self {
		case .signUp:
			return "/signUp"
		case .signIn:
			return "/signIn"
		case .emailDup:
			return "/email"
		case .sendCertifyCode, .confirmCertifyCode, .resettingPassword:
			return "/password"
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
		case .sendCertifyCode(let query):
			return .query([
				"email": query.email
			])
		case .confirmCertifyCode(let body):
			return .body(body)
		case .resettingPassword(let body):
			return .body(body)
		}
	}
	
}
