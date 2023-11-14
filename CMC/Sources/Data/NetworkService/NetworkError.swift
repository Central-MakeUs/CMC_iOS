//
//  NetworkError.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

struct ServerError: Codable {
	let isSuccess: Bool
	let code: String
	let message: String
}


public enum NetworkError: LocalizedError {
	case invalidURL
	case invalidResponse
	case decodingFailed
	case badNetwork
	case customError(code: String?, message: String?)
	
	public var errorDescription: String {
		switch self {
		case .invalidURL:
			return "The URL is invalid."
		case .invalidResponse:
			return "The response is invalid."
		case .decodingFailed:
			return "Failed to decode the object."
		case .badNetwork:
			return "The network is unstable."
		case .customError(_, let message):
			return "\(message ?? "Unknown Error")"
		}
	}
	
	static func error(from code: Int, serverMessage: String?) -> NetworkError {
		let defaultMessage: String
		switch code {
		case 400:
			defaultMessage = "Bad Request"
		case 401:
			defaultMessage = "Unauthorized"
		case 403:
			defaultMessage = "Forbidden"
		case 404:
			defaultMessage = "Not Found"
		default:
			defaultMessage = "Unknown Error"
		}
		
		let message = serverMessage ?? defaultMessage
		return .customError(code: "\(code)", message: message)
	}
}
