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
	}
	
	struct Output {
		let certifyEmail: Observable<Bool>
		let emailValidation: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	private var allcertifyEmailRelay = BehaviorRelay<Bool>(value: false)
	
	func transform(input: Input) -> Output {
		let emailValidation: Observable<Bool> = Utility.checkEmailValidation(email: input.email, validate: .emailRegex)
		
		input.email
			.withUnretained(self)
			.subscribe(onNext: { owner, email in
				owner.allcertifyEmailRelay.accept(!email.isEmpty)
			})
			.disposed(by: disposeBag)
		
		return Output(
			certifyEmail: allcertifyEmailRelay.asObservable(),
			emailValidation: emailValidation
		)
	}
	
}

