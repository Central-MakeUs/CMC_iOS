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
	}
	
	struct Output {
		let sendCertifyResult: Observable<Bool>
		let nextAvailable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	private let usecase: AuthUsecase
	
	private let nextAvailable = BehaviorRelay<Bool>(value: false)
	
	init(
		usecase: AuthUsecase
	) {
		self.usecase = usecase
	}
	
	
	func transform(input: Input) -> Output {
		
		input.certifiedCode
			.withUnretained(self)
			.subscribe(onNext: { owner, code in
				code.count >= 6 ? owner.nextAvailable.accept(true) : owner.nextAvailable.accept(false)
			})
			.disposed(by: disposeBag)
		
		
		let sendCertifyResult = input.reSendButtonTapped
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
			nextAvailable: nextAvailable.asObservable()
		)
		
	}
	
	
}
