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
	
	let emailRelay = PublishRelay<String>()
	let passwordRelay = PublishRelay<String>()
	let nicknameRelay = PublishRelay<String>()
	let nameRelay = PublishRelay<String>()
	let generationRelay = PublishRelay<Int>()
	let positionRelay = PublishRelay<String>()
	
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
		
		input.nextButtonTapped
			.withLatestFrom(Observable.combineLatest(
				input.nowPage,
				Observable.combineLatest(
					emailRelay,
					passwordRelay,
					nicknameRelay,
					nameRelay,
					generationRelay,
					positionRelay
				)
			))
			.flatMapLatest { [weak self] (nowPage, data) -> Observable<Result<SignUpModel, Error>> in
				let (email, password, nickname, name, generation, part) = data
				guard let self = self, nowPage == input.totalPage else { return .empty() }
				
				let body = SignUpBody(email: email, password: password, nickname: nickname, name: name, generation: generation, part: part)
				return self.authUsecase.signUp(body: body)
					.map { Result.success($0) }
					.catch { error in
						return .just(Result.failure(error))
					}
					.asObservable()
			}
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, result in
				switch result {
				case .success(let model):
					//MARK: - 흠,,, 회원 수락을 직접 해주는거면, 이 친구들 저장 할 필요가 없지않나,,,?
					/*
					UserDefaultManager.shared.save(model.accessToken, for: .accessToken)
					UserDefaultManager.shared.save(model.refreshToken, for: .refreshToken)
					 */
					let signUpCompletedViewController = SignUpCompletedViewController(
						viewModel: SignUpCompletedViewModel(
							coordinator: owner.coordinator
						)
					)
					owner.coordinator?.presentViewController(viewController: signUpCompletedViewController, style: .overFullScreen)
				case .failure(let error):
					CMCToastManager.shared.addToast(message: "회원가입에 실패했습니다: \(error.localizedDescription)")
				}
			})
			.disposed(by: disposeBag)
		
		
		return Output(
			readyForNextButton: readyForNextButton.asObservable(),
			navigationAccessoryText: navigationAccessoryText,
			nextButtonTitle: nextbuttonTitle
		)
	}
}
