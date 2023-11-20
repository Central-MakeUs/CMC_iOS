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
		let password: Observable<String>
		let rePassword: Observable<String>
	}
	
	struct Output {
		let passwordValidations: [Observable<Bool>]
		let passwordConfirmRegex: Observable<Bool>
		let nextAvailable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - Initializers
	init() {
		
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
		
		let nextAvailable = Observable.combineLatest(
			passwordRegex,
			passwordConfirmRegex
		)
			.map { $0 && $1 }
		
		return Output(
			passwordValidations: passwordValidations,
			passwordConfirmRegex: passwordConfirmRegex,
			nextAvailable: nextAvailable
		)
	}
	
}
