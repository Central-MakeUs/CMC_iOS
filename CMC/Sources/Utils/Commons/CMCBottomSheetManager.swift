//
//  CMCBottomSheetManager.swift
//  DesignSystem
//
//  Created by Siri on 11/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import RxSwift

import DesignSystem
import UIKit

class CMCBottomSheetManager {
	
	static let shared = CMCBottomSheetManager()
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	private init() {
		
	}
	
	func showBottomSheet(title: String, body: String?, buttonTitle: String) {
		
		let backgroundView: UIView = {
			let view = UIView()
			view.backgroundColor = CMCAsset.black1.color.withAlphaComponent(0.7)
			return view
		}()
		
		let newBottomSheet = CMCBottomSheet(
			title: title,
			body: body,
			buttonTitle: buttonTitle
		)
		
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let window = windowScene.windows.first {
				window.addSubview(backgroundView)
				backgroundView.addSubview(newBottomSheet)
				
				backgroundView.snp.makeConstraints { make in
					make.edges.equalToSuperview()
				}
				
				newBottomSheet.snp.makeConstraints { make in
					make.bottom.equalToSuperview()
					make.leading.trailing.equalToSuperview()
					make.height.equalTo(288)
				}
				
			}
		}
		
		backgroundView.alpha = 0.0
		newBottomSheet.isHidden = true
		
		backgroundView.fadeIn(completion: { _ in
			newBottomSheet.bottomToUp()
		})
		
		
		newBottomSheet.cancelButton.rx.tap
			.subscribe(onNext: { _ in
				newBottomSheet.topToDown(completion: { _ in
					backgroundView.fadeOut(completion: { _ in backgroundView.removeFromSuperview() })
				})
			})
			.disposed(by: disposeBag)
	}
	
	
}

extension UIView {
	fileprivate func fadeIn(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1.0
		}, completion: completion)
	}
	
	fileprivate func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0.0
		}, completion: completion)
	}
}

extension UIView {
	fileprivate func bottomToUp(duration: TimeInterval = 0.3) {
		self.isHidden = false
		self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
		UIView.animate(withDuration: duration) {
			self.transform = CGAffineTransform.identity
		}
	}
	
	fileprivate func topToDown(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: duration, animations: {
			self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
		}, completion: completion)
	}
}
