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
					print("🍎 발급받은 악세스토큰: \(model.accessToken) 🍎")
					self?.coordinator?.finish()
				case .failure(let error):
					print("🍎 발생한 에러: \(error) 🍎")
					CMCToastManager.shared.addToast(message: "😵‍💫 로그인에 실패했습니다 ㅜ..ㅜ 😵‍💫")
				}
			})
			.disposed(by: disposeBag)
		
		input.backBtnTapped
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController()
			})
			.disposed(by: disposeBag)
		
		return Output(
			signInBtnEnable: signInBtnEnable
		)
	}
	
	
}
