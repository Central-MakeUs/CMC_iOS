//
//  CMCToastManager.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import SnapKit

import UIKit

final class CMCToastManager {
	
	// MARK: - Properties
	static let shared = CMCToastManager()
	private var currentToastView: ToastView?
	
	// MARK: - Initializers
	private init() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
	}
	
	// MARK: - Functions
	func addToast(message: String) {
		self.showToast(message: message)
	}
	
	private func showToast(message: String) {
		let scenes = UIApplication.shared.connectedScenes
		let windowScene = scenes.first as? UIWindowScene
		guard let window = windowScene?.windows.first else { return }
		
		let toastView = ToastView(frame: window.bounds, message: message)
		window.addSubview(toastView)
		currentToastView = toastView
		
		setupToastConstraints(toastView, in: window)
		
		UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut, animations: {
			self.currentToastView?.alpha = 0
		}, completion: { _ in
			self.currentToastView?.removeFromSuperview()
			self.currentToastView = nil
		})
	}
	
	private func setupToastConstraints(_ toastView: ToastView, in window: UIWindow) {
		toastView.snp.makeConstraints { make in
			make.centerX.equalTo(window.snp.centerX)
			make.width.equalTo(284)
			make.bottom.equalTo(window.snp.bottom).offset(-122)
		}
	}
	
	@objc private func keyboardWillShow(_ notification: Notification) {
		if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
			adjustToastForKeyboard(show: true, keyboardFrame: keyboardFrame)
		}
	}
	
	
	private func adjustToastForKeyboard(show: Bool, keyboardFrame: CGRect) {
		guard let toastView = currentToastView else { return }
		
		var newOffset = -122
		if show {
			newOffset -= Int(keyboardFrame.height)
		}
		
		toastView.snp.updateConstraints { make in
			make.bottom.equalToSuperview().offset(newOffset)
		}
		
		UIView.animate(withDuration: 0.25) {
			toastView.superview?.layoutIfNeeded()
		}
	}
}


private class ToastView: UIView {
	let toastLabel = UILabel()
	
	init(
		frame: CGRect,
		message: String
	) {
		super.init(frame: frame)
		
		self.backgroundColor = CMCAsset.gray500.color
		self.alpha = 0.8
		self.clipsToBounds = true
		
		toastLabel.textColor = CMCAsset.gray50.color
		toastLabel.font = CMCFontFamily.Pretendard.bold.font(size: 14)
		toastLabel.textAlignment = .center
		toastLabel.text = message
		toastLabel.numberOfLines = 0
		toastLabel.sizeToFit()
		toastLabel.clipsToBounds = true
		
		self.addSubview(toastLabel)
		
		self.setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints() {
		toastLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(14)
			make.bottom.equalToSuperview().offset(-14)
			make.leading.equalToSuperview().offset(40)
			make.trailing.equalToSuperview().offset(-40)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.frame.height / 2
	}
	
}
