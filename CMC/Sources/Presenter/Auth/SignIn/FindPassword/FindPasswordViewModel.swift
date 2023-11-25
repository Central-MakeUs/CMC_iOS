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
		let nowPage: Observable<Int>
	}
	
	struct Output {
		
	}
	
	// MARK: - Properties
	private var authUsecase: AuthUsecase
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	let email = BehaviorRelay<String>(value: "")
	let nowPage = BehaviorRelay<Int>(value: 0)
	
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

		input.backButtonTapped
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController()
			})
			.disposed(by: disposeBag)
		
		input.nowPage
			.withUnretained(self)
			.subscribe(onNext: { owner, page in
				owner.nowPage.accept(page)
			})
			.disposed(by: disposeBag)
		
		return Output()
	}
}
