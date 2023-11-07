//
//  MainSignUpViewModel.swift
//  CMC
//
//  Created by Siri on 10/28/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class MainSignUpViewModel: ViewModelType {
	
	struct Input {
		let email: Observable<String>
		let password: Observable<String>
		let rePassword: Observable<String>
		let name: Observable<String>
		let emailDupTapped: Observable<Void>
	}
	
	struct Output {
		let emailDuplicate: Observable<(Bool, String)>
		let passwordValidations: [Observable<Bool>]
		let passwordConfirmRegex: Observable<Bool>
		let nextAvailable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	private var authUsecase: AuthUsecase
	
	private var emailDupResult = PublishRelay<(Bool, String)>()
	
	// MARK: - Initializers
	init(
		authUsecase: AuthUsecase
	) {
		self.authUsecase = authUsecase
	}
	
	func transform(input: Input) -> Output {
		
		input.emailDupTapped
			.withLatestFrom(input.email)
			.withUnretained(self)
			.flatMap { owner, email -> Observable<(Bool, String)> in
				let query = EmailDupQuery(email: email)
				return owner.authUsecase.emailDup(query: query)
					.asObservable()
					.map { (true, $0.message) }
					.catch { error -> Observable<(Bool, String)> in
						guard let customError = (error as? NetworkError)?.errorDescription else { return .empty() }
						return .just((false, customError))
					}
			}
			.bind(to: emailDupResult)
			.disposed(by: disposeBag)
		
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
		
		let nameRegex = input.name
			.map { !$0.isEmpty }
		
		let nextAvailable = Observable.combineLatest(
			emailDupResult.asObservable(),
			passwordRegex,
			passwordConfirmRegex,
			nameRegex
		)
			.map { $0.0 && $1 && $2 && $3 }
		
		return Output(
			emailDuplicate: emailDupResult.asObservable(),
			passwordValidations: passwordValidations,
			passwordConfirmRegex: passwordConfirmRegex,
			nextAvailable: nextAvailable
		)
	}
	
}
