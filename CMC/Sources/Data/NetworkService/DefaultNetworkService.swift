//
//  DefaultNetworkService.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxSwift

final class DefaultNetworkService: NetworkService {
	
	// MARK: - Properties
	private let session: URLSession = .shared
	
	
	// MARK: - Methods
	
	func request(_ endpoint: Endpoint) -> Observable<(HTTPURLResponse, Data)> {
		guard let urlRequest = endpoint.toURLRequest() else {
			return .error(NetworkError.invalidURL)
		}
		return session.rx
			.response(request: urlRequest)
			.map { ($0.response, $0.data) }
	}
	
	func request(_ endpoint: Endpoint) -> Single<Data> {
		return self.request(endpoint)
			.do(onSubscribe: {
				CMCIndecatorManager.shared.show()
			}, onDispose: {
				CMCIndecatorManager.shared.hide()
			})
			.flatMap { response, data -> Observable<Data> in
				if response.statusCode == 200 {
					return .just(data)
				} else {
					let errorData = Utility.decodeError(from: data)
					return .error(NetworkError.customError(code: errorData.code, message: errorData.message))
				}
			}
			.asSingle()
	}
	
}
