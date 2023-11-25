//
//  NetworkService.swift
//  CMC
//
//  Created by Siri on 2023/10/22.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxSwift

protocol NetworkService {
	
	// MARK: - Methods
	func request(_ endpoint: Endpoint) -> Observable<(HTTPURLResponse, Data)>
	func request(_ endpoint: Endpoint) -> Single<Data>
}
