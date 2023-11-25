//
//  ResettingPasswordViewModel.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class ResettingPasswordViewModel: ViewModelType {
	
	struct Input {
		let email: Observable<String>
		let password: Observable<String>
		let rePassword: Observable<String>
		let reSettingPasswordTapped: Observable<Void>
	}
	
	struct Output {
		let passwordValidations: [Observable<Bool>]
		let passwordConfirmRegex: Observable<Bool>
		let reSettingButtonActive: Observable<Bool>
		let reSettingPasswordResult: Observable<Bool>
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
		
		let passwordValidations: [Observable<Bool>] = [
			.englishRegex,
			.numberRegex,
			.lengthRegex
		].map({validate in
			Utility.checkPasswordValidation(password: input.password, validate: validate)
		})
		
		let passwordRegex = Observable.combineLatest(passwordValidations)
			.map { $0.allSatisfy { $0 } }
		
		let passwordConfirmRegex = Observable.combineLatest(input.password, input.rePassword)
			.map { $0 == $1 && !$0.isEmpty}
		
		let reSettingButtonActive = Observable.combineLatest(
			passwordRegex,
			passwordConfirmRegex
		)
			.map { $0 && $1 }
		
		let reSettingPasswordResult = input.reSettingPasswordTapped
			.withLatestFrom(Observable.combineLatest(input.email, input.password))
			.withUnretained(self)
			.flatMapLatest { owner, result -> Observable<Bool> in
				let (email, password) = result
				let body = ResettingPasswordBody(email: email, password: password)
				return owner.usecase.reSettingPassword(body: body)
					.asObservable()
					.map { _ in true}
					.catch { _ in
						return .just(false)
					}
			}
			.share()
		
		return Output(
			passwordValidations: passwordValidations,
			passwordConfirmRegex: passwordConfirmRegex,
			reSettingButtonActive: reSettingButtonActive,
			reSettingPasswordResult: reSettingPasswordResult
		)
	}
	
}
