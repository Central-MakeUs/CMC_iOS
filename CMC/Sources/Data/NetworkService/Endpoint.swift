//
//  Endpoint.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case GET, POST, DELETE, FETCH
}

typealias HTTPHeaders = [String: String]

/// HTTPRequestParameter타입이 쿼리인지 바디인지에 따라서 setBody에 값을 넣을건지 appendingQueries에 값을 넣을건지 판별하기 위함
public enum HTTPRequestParameterType {
	
	case query([String: String])
	case body(Encodable)
}

// MARK: - Endpoint
protocol Endpoint {
	
	var baseURL: URL? { get }
	var method: HTTPMethod { get }
	var headers: HTTPHeaders { get }
	var path: String { get }
	var parameters: HTTPRequestParameterType? { get }
	
	func toURLRequest() -> URLRequest?
}

extension Endpoint {
	
	/// 기본 헤더타입 세팅 (어지간하면 json기반이지 않을까..?)
	/// application/x-www-form-urlencoded 요 타입일 경우가 있을수도??
	var headers: HTTPHeaders {
		return ["Content-Type": "application/json"]
	}
	
	/// 최종 완성된 URLSession.shared.request()
	func toURLRequest() -> URLRequest? {
		guard let url = configureURL() else { return nil }
		
		return URLRequest(url: url)
			.setMethod(method)
			.appendingHeaders(headers)
			.setBody(at: parameters)
	}
	
	/// BaseURL을 기반으로 추가 도메인을 세팅해줌. 또한, 이후에 .body인지 .query인지에 따라서 추가 쿼리문이 붙어온다.
	private func configureURL() -> URL? {
		return baseURL?
			.appendingPath(path)
			.appendingQueries(at: parameters)
	}
}

extension URL {
	
	/// BaseURL이후의 추가 도메인을 이어붙여줌
	func appendingPath(_ path: String) -> URL {
		return self.appendingPathComponent(path)
	}
	
	/// setBody와 마찬가지로, HTTPRequestParameter가 쿼리타입일 경우 URL에 쿼리값을 추가해줌.
	func appendingQueries(at parameter: HTTPRequestParameterType?) -> URL? {
		var components = URLComponents(string: self.absoluteString)
		if case .query(let queries) = parameter {
			components?.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
		}
		
		return components?.url
	}
}

extension URLRequest {
	
	/// URLSession 통신 타입 설정 (get, post, delete, fetch)
	func setMethod(_ method: HTTPMethod) -> URLRequest {
		var urlRequest = self
		
		urlRequest.httpMethod = method.rawValue
		return urlRequest
	}
	
	/// URLSession 헤더 추가 (Dict타입으로 $0이 필드명, $1이 타이틀)
	func appendingHeaders(_ headers: HTTPHeaders) -> URLRequest {
		var urlRequest = self
		
		headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
		return urlRequest
	}
	
	/// URLSession 바디 추가 (파라미터로 보내야하는 값들. 단, HTTPRequestParameter가 쿼리타입인지 바디타입인지에 따라서 다름. 쿼리타입이면 바디 세팅 안함)
	func setBody(at parameter: HTTPRequestParameterType?) -> URLRequest {
		var urlRequest = self
		
		if case .body(let body) = parameter {
			urlRequest.httpBody = try? JSONEncoder().encode(body)
		}
		return urlRequest
	}
}
