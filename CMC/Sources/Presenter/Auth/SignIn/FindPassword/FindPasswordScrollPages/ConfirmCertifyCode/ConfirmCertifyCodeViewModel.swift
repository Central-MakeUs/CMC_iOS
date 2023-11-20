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
		let nowPage: Observable<Int>
		let certifiedCode: Observable<String>
		let reSendButtonTapped: Observable<Void>
	}
	
	struct Output {
		let startTimer: Observable<Bool>
		let nextAvailable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	private let usecase: AuthUsecase
	
	private let startTimer = BehaviorRelay<Bool>(value: false)
	private let nextAvailable = BehaviorRelay<Bool>(value: false)
	
	init(
		usecase: AuthUsecase
	) {
		self.usecase = usecase
	}
	
	
	func transform(input: Input) -> Output {
		
		input.nowPage
			.withUnretained(self)
			.subscribe(onNext: { owner, page in
				if page == 2 {
					owner.startTimer.accept(true)
				}
			})
			.disposed(by: disposeBag)
		
		input.certifiedCode
			.withUnretained(self)
			.subscribe(onNext: { owner, code in
				code.count >= 6 ? owner.nextAvailable.accept(true) : owner.nextAvailable.accept(false)
			})
			.disposed(by: disposeBag)
		
		return Output(
			startTimer: startTimer.asObservable(),
			nextAvailable: nextAvailable.asObservable()
		)
		
	}
	
	
}
