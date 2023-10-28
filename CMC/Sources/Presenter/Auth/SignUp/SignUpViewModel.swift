//
//  SignUpViewModel.swift
//  CMC
//
//  Created by Siri on 10/26/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class SignUpViewModel: ViewModelType{
	
	struct Input {
		let backButtonTapped: Observable<Void>
		let nowPage: Observable<Int>
		let totalPage: Int
	}
	
	struct Output {
		let nextBtnTapped: Observable<Void>
		let backButtonHidden: Observable<Bool>
		let navigationAccessoryText: Observable<String>
	}
	
	// MARK: - Properties
	private var authUsecase: AuthUsecase
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	let nextBtnTapped = PublishRelay<Void>()
	
	private let backButtonHidden = BehaviorSubject<Bool>(value: false)
	
	// MARK: - Initializers
	init(
		coordinator: AuthCoordinator,
		authUsecase: AuthUsecase
	) {
		self.coordinator = coordinator
		self.authUsecase = authUsecase
	}
	
	// MARK: - Methods
	func transform(input: Input) -> Output {

		input.backButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController()
			})
			.disposed(by: disposeBag)
		
		input.nowPage
			.withUnretained(self)
			.subscribe(onNext: { owner, page in
				owner.backButtonHidden.onNext(page >= 3)
			})
			.disposed(by: disposeBag)
		
		let navigationAccessoryText = input.nowPage
			.map { page in
				return "\(page)/\(input.totalPage)"
			}
		
		return Output(
			nextBtnTapped: nextBtnTapped.asObservable(),
			backButtonHidden: backButtonHidden.asObservable(),
			navigationAccessoryText: navigationAccessoryText
		)
	}
}
