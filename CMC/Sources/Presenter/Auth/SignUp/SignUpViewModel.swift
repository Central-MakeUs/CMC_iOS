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
		let nextButtonTapped: Observable<Void>
		let nowPage: Observable<Int>
		let totalPage: Int
	}
	
	struct Output {
		let readyForNextButton: Observable<Bool>
		let navigationAccessoryText: Observable<String>
		let nextButtonTitle: Observable<String>
	}
	
	// MARK: - Properties
	private var authUsecase: AuthUsecase
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	let readyForNextButton = BehaviorRelay<Bool>(value: false)
	
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
		
		input.nextButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.readyForNextButton.accept(false)
			})
			.disposed(by: disposeBag)

		input.backButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController()
			})
			.disposed(by: disposeBag)
		
		let navigationAccessoryText = input.nowPage
			.map { page in
				return "\(page)/\(input.totalPage)"
			}
		
		let nextbuttonTitle = input.nowPage
			.map { page in
				return page == input.totalPage ? "가입 신청하기" : "다음"
			}
		
		return Output(
			readyForNextButton: readyForNextButton.asObservable(),
			navigationAccessoryText: navigationAccessoryText,
			nextButtonTitle: nextbuttonTitle
		)
	}
}
