//
//  CustomAsyncQueue.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

typealias ClosureToWork = (CustomAsyncQueue) -> Void

/// 로딩되는 동작 처리 할 큐
class CustomAsyncQueue {
		static var shared = CustomAsyncQueue()
		
		var queue: [ClosureToWork] = []
		
		var dispatchQueue: DispatchQueue? = nil // = OS_dispatch_queue_serial(label: "CustomAsyncQueue")
		
		/// 인자가 없으면 메인 큐.
		private init(dispatchQueue: DispatchQueue? = nil) {
				self.dispatchQueue = dispatchQueue// ?? OS_dispatch_queue_main(label: "CustomAsyncQueueMain")
		}
		
		func append(toWork: @escaping ClosureToWork) {
				queue.append(toWork)
		}

		func next() {
				if let toWork = self.queue.first {
						self.queue.removeFirst()
						
						if dispatchQueue == nil {
								OperationQueue.main.addOperation {
										toWork(self) // 진행 시켜!
								}
						}
						else {
								dispatchQueue?.async {
										toWork(self) // 비동기로 진행시켜~
								}
						}
				}
		}
}
