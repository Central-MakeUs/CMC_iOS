//
//  NetworkStateManager.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import UIKit

import Network

import RxSwift

final class NetworkMonitor{
		static let shared = NetworkMonitor()
		
		private let monitor: NWPathMonitor  /// 현재 인터넷 연결상태 확인 모니터
		private let disposeBag = DisposeBag()
			 
		init() {
				monitor = NWPathMonitor()
		}
		
		func checkNetworkStatus() -> Single<Bool> {
				return Single<Bool>.create { [weak self] single in
						guard let self = self else { return Disposables.create() }
						
						self.monitor.pathUpdateHandler = { path in
								if path.status == .satisfied {
										single(.success(true))
								} else {
										single(.failure(NetworkError.badNetwork))
								}
								self.stopMonitoring()
						}
						self.monitor.start(queue: .global())
						
						return Disposables.create {
								self.stopMonitoring()
						}
				}
		}
		
		private func stopMonitoring() {
				monitor.cancel()
		}
}
