//
//  CMCBottomDropDownSheetManager.swift
//  CMC
//
//  Created by Siri on 11/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import RxSwift

import DesignSystem
import UIKit

class CMCBottomDropDownSheetManager {
	
	static let shared = CMCBottomDropDownSheetManager()
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	private init() {
		
	}
	
	func bottomDropDownSheetResponse(title: String, dataSource: [String], buttonTitle: String) -> Observable<String> {
		return Observable.create { observer in
			let dropDownActionObservable = self.showBottomDropDownSheet(
				title: title,
				dataSource: dataSource,
				buttonTitle: buttonTitle
			)
			let subscription = dropDownActionObservable
				.subscribe { selectedTitle in
				observer.onNext(selectedTitle)
				observer.onCompleted()
			}
			return Disposables.create {
				subscription.dispose()
			}
		}
	}
	
	func showBottomDropDownSheet(title: String, dataSource: [String], buttonTitle: String) -> PublishSubject<String> {
		
		let dropDownActionSubject = PublishSubject<String>()
		
		let backgroundView: UIView = {
			let view = UIView()
			view.backgroundColor = CMCAsset.black1.color.withAlphaComponent(0.7)
			return view
		}()
		
		let newBottomDropDownSheet = CMCBottomDropDownSheet(
			title: title,
			dropDownDataSource: dataSource,
			buttonTitle: buttonTitle
		)
		
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let window = windowScene.windows.first {
				window.addSubview(backgroundView)
				backgroundView.addSubview(newBottomDropDownSheet)
				
				backgroundView.snp.makeConstraints { make in
					make.edges.equalToSuperview()
				}
				
				newBottomDropDownSheet.snp.makeConstraints { make in
					make.bottom.equalToSuperview()
					make.leading.trailing.equalToSuperview()
					make.height.equalTo(600)
				}
				
			}
		}
		
		backgroundView.alpha = 0.0
		newBottomDropDownSheet.isHidden = true
		
		backgroundView.fadeIn(completion: { _ in
			newBottomDropDownSheet.bottomToUp()
		})
		
		
		newBottomDropDownSheet.cancelButton.rx.tap
			.subscribe(onNext: { _ in
				newBottomDropDownSheet.topToDown(completion: { _ in
					backgroundView.fadeOut(completion: { _ in backgroundView.removeFromSuperview() })
				})
			})
			.disposed(by: disposeBag)
		
		newBottomDropDownSheet.itemSelected
			.subscribe(onNext: { selectedTitle in
				newBottomDropDownSheet.topToDown(completion: { _ in
					dropDownActionSubject.onNext(selectedTitle)
					dropDownActionSubject.onCompleted()
					backgroundView.fadeOut(completion: { _ in
						backgroundView.removeFromSuperview()
					})
				})
			})
			.disposed(by: disposeBag)
		return dropDownActionSubject
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
