//
//  SignInViewModel.swift
//  CMC
//
//  Created by Siri on 10/26/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class SignInViewModel: ViewModelType{
	
	struct Input {
		let email: Observable<String>
		let password: Observable<String>
		let backBtnTapped: Observable<Void>
		let forgetIDBtnTapped: Observable<Void>
		let forgetPasswordBtnTapped: Observable<Void>
		let goSignUpButtonTapped: Observable<Void>
		let goSignInButtonTapped: Observable<Void>
	}
	
	struct Output {
		let signInBtnEnable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	private let authUsecase: AuthUsecase
	
	init(
		coordinator: AuthCoordinator,
		authUsecase: AuthUsecase
	) {
		self.coordinator = coordinator
		self.authUsecase = authUsecase
	}
	
	func transform(input: Input) -> Output {
		let signInBtnEnable = Observable.combineLatest(input.email, input.password)
			.map { email, password in
				return !email.isEmpty && !password.isEmpty
			}
		
		input.goSignInButtonTapped
			.withLatestFrom(Observable.combineLatest(input.email, input.password))
			.flatMapLatest { [weak self] email, password -> Observable<Result<SignInModel, Error>> in
				guard let self = self else { return .empty() }
				let body = SignInBody(email: email, password: password)
				return self.authUsecase.signIn(body: body)
					.map { Result.success($0) }
					.catch { error in
						return .just(Result.failure(error))
					}
					.asObservable()
			}
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] result in
				switch result {
				case .success(let model):
					UserDefaultManager.shared.save(model.accessToken, for: .accessToken)
					UserDefaultManager.shared.save(model.refreshToken, for: .refreshToken)
					self?.coordinator?.finish()
				case .failure(_):
					CMCBottomSheetManager.shared.showBottomSheet(
						title: "존재하지 않는 계정이에요",
						body: "아이디 또는 비밀번호를 확인해주세요!",
						buttonTitle: "확인"
					)
				}
			})
			.disposed(by: disposeBag)
		
		input.goSignUpButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.userActionState.accept(.signUp)
			})
			.disposed(by: disposeBag)
		
		input.forgetIDBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				CMCBottomSheetManager.shared.showBottomSheet(
					title: "아이디 찾기는\n운영진에게 문의해주세요 :)",
					body: nil,
					buttonTitle: "확인"
				)
			})
			.disposed(by: disposeBag)
		
		input.backBtnTapped
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		input.forgetPasswordBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				let findPasswordViewController = FindPasswordViewController(
					viewModel: FindPasswordViewModel(
						coordinator: owner.coordinator,
						authUsecase: owner.authUsecase
					)
				)
				owner.coordinator?.pushViewController(viewController: findPasswordViewController, animated: true)
			})
			.disposed(by: disposeBag)
		
		return Output(
			signInBtnEnable: signInBtnEnable
		)
	}
	
	
}
