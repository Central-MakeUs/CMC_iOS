//
//  ConfirmCertifyCodeViewModel.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift


final class ConfirmCertifyCodeViewModel: ViewModelType {
	
	struct Input {
		let email: Observable<String>
		let certifiedCode: Observable<String>
		let reSendButtonTapped: Observable<Void>
		let certifyCodeTapped: Observable<Void>
	}
	
	struct Output {
		let resendCertifyCode: Observable<Bool>
		let certifyCodeResult: Observable<Bool>
		let codeValidation: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	private let usecase: AuthUsecase
	
	// MARK: - Initializers
	init(
		usecase: AuthUsecase
	) {
		self.usecase = usecase
	}
	
	func transform(input: Input) -> Output {
		
		let resendCertifyCode = input.reSendButtonTapped
			.withLatestFrom(input.email)
			.withUnretained(self)
			.flatMapLatest { owner, email -> Observable<Bool> in
				let query = SendCertifyCodeQuery(email: email)
				return owner.usecase.sendCertifyCode(query: query)
					.asObservable()
					.map { _ in true}
					.catch { _ in
						return .just(false)
					}
			}
			.share()
		
		let certifyCodeResult = input.certifyCodeTapped
			.withLatestFrom(Observable.combineLatest(input.certifiedCode, input.email))
			.withUnretained(self)
			.flatMapLatest { owner, result -> Observable<Bool> in
				let (code, email) = result
				let body = ConfirmCertifyCodeBody(email: email, code: code)
				return owner.usecase.confirmCertifyCode(body: body)
					.asObservable()
					.map { _ in true}
					.catch { _ in
						return .just(false)
					}
			}
			.share()
											 
		let codeValidation = input.certifiedCode
			.map { code -> Bool in
				return code.count >= 6
			}
			.asObservable()
		
		return Output(
			resendCertifyCode: resendCertifyCode,
			certifyCodeResult: certifyCodeResult,
			codeValidation: codeValidation
		)
		
	}
	
	
}
