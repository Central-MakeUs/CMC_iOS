//
//  MainAuthViewModel.swift
//  CMC
//
//  Created by Siri on 10/25/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class MainAuthViewModel: ViewModelType{
	
	struct Input {
		let signInBtnTapped: Observable<Void>
		let signUpBtnTapped: Observable<Void>
	}
	
	struct Output {}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: AuthCoordinator?
	
	init(
		coordinator: AuthCoordinator
	) {
		self.coordinator = coordinator
	}
	
	
	func transform(input: Input) -> Output {
		input.signInBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.userActionState.accept(.emailSignIn)
		}).disposed(by: disposeBag)
		
		input.signUpBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.userActionState.accept(.emailSignUp)
		}).disposed(by: disposeBag)
		
		return Output()
	}
	
}
