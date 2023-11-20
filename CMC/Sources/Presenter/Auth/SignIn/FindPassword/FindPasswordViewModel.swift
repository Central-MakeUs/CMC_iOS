//
//  FindPasswordViewModel.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class FindPasswordViewModel: ViewModelType{
	
	struct Input {
		let backButtonTapped: Observable<Void>
		let nextButtonTapped: Observable<Void>
		let nowPage: Observable<Int>
	}
	
	struct Output {
		let readyForNextButton: Observable<Bool>
	}
	
	// MARK: - Properties
	private var authUsecase: AuthUsecase
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	let readyForNextButton = BehaviorRelay<Bool>(value: true)
	let email = BehaviorRelay<String>(value: "")
	
	// MARK: - Initializers
	init(
		coordinator: AuthCoordinator?,
		authUsecase: AuthUsecase
	) {
		self.coordinator = coordinator
		self.authUsecase = authUsecase
	}
	
	// MARK: - Methods
	func transform(input: Input) -> Output {
		
		input.nextButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.readyForNextButton.accept(false)
			})
			.disposed(by: disposeBag)

		input.backButtonTapped
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController()
			})
			.disposed(by: disposeBag)
		
		return Output(
			readyForNextButton: readyForNextButton.asObservable()
		)
	}
}
