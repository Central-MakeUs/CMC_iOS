//
//  NotificationManager.swift
//  CMC
//
//  Created by Siri on 10/28/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxSwift
import UIKit

class NotificationManager {
		static let shared = NotificationManager()
		
		// 키보드 높이를 전달할 Subject
		let keyboardHeightSubject = PublishSubject<CGFloat>()
		
		private init() {
				NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
				NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		}
		
		@objc private func keyboardWillShow(_ notification: Notification) {
				if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
						let keyboardRectangle = keyboardFrame.cgRectValue
						let keyboardHeight = keyboardRectangle.height
						keyboardHeightSubject.onNext(keyboardHeight)
				}
		}
		
		@objc private func keyboardWillHide(_ notification: Notification) {
				keyboardHeightSubject.onNext(0)
		}
}
