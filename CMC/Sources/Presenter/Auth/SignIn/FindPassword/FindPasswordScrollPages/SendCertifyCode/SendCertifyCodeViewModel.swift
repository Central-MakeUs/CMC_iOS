//
//  SendCertifyCodeViewModel.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class SendCertifyCodeViewModel: ViewModelType {
	
	struct Input {
		let email: Observable<String>
		let receiveCertifyTapped: Observable<Void>
	}
	
	struct Output {
		let sendCertifyResult: Observable<Bool>
		let emailValidation: Observable<Bool>
	}
	
	// MARK: - Properties
	var disposeBag: DisposeBag = DisposeBag()
	private let usecase: AuthUsecase
	
	// MARK: - Initializers
	init(
		usecase: AuthUsecase
	) {
		self.usecase = usecase
	}
	
	private var allcertifyEmailRelay = BehaviorRelay<Bool>(value: false)
	
	func transform(input: Input) -> Output {
		let emailValidation: Observable<Bool> = Utility.checkEmailValidation(email: input.email, validate: .emailRegex)
		
		let sendCertifyResult = input.receiveCertifyTapped
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
		
		return Output(
			sendCertifyResult: sendCertifyResult,
			emailValidation: emailValidation
		)
	}
	
}

