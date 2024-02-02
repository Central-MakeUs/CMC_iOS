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
	private let userUsecase: UserUsecase
	
	private let userDataUsecase = DefaultUserDataUsecase()
	private let notificationDataUsecase = DefaultNotificationsDataUsecase()
	private let authDataUsecase = DefaultAuthDataUsecase()
	
	init(
		coordinator: AuthCoordinator,
		authUsecase: AuthUsecase,
		userUsecase: UserUsecase
	) {
		self.coordinator = coordinator
		self.authUsecase = authUsecase
		self.userUsecase = userUsecase
	}
	
	func transform(input: Input) -> Output {
		let signInBtnEnable = Observable.combineLatest(input.email, input.password)
			.map { email, password in
				return !email.isEmpty && !password.isEmpty
			}
		
		let loginObservable = input.goSignInButtonTapped
			.withLatestFrom(Observable.combineLatest(input.email, input.password))
			.flatMapLatest { [weak self] email, password -> Observable<SignInModel> in
				guard let self = self else { return Observable.error(NetworkError.customError(code: "404", message: "Strong Self")) }
				let signInBody = SignInBody(email: email, password: password)
				return self.authUsecase.signIn(body: signInBody)
					.observe(on: MainScheduler.instance)
					.asObservable()
					.catch { error in
						CMCBottomSheetManager.shared.showBottomSheet(
							title: "존재하지 않는 계정이에요",
							body: "아이디 또는 비밀번호를 확인해주세요!",
							buttonTitle: "확인"
						)
						return Observable.empty()
					}
			}
		
		// 로그인 성공 후 사용자 정보 처리
		loginObservable
			.withUnretained(self)
			.flatMapLatest { owner, signInModel -> Observable<GetUserModel> in
				owner.authDataUsecase.saveAuthData(signInModel: signInModel)
				return owner.userUsecase.getUser()
					.asObservable()
					.observe(on: MainScheduler.instance)
					.catch { error in
						CMCBottomSheetManager.shared.showBottomSheet(
							title: "사용자 정보를 불러오는데 실패하였습니다.",
							body: "\(error.localizedDescription)",
							buttonTitle: "확인"
						)
						return Observable.empty()
					}
			}
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, userModel in
				owner.userDataUsecase.saveUserData(userData: userModel)
				owner.coordinator?.finish()
			}, onError: { [weak self] error in
				self?.userDataUsecase.saveNoneUserData()
			})
			.disposed(by: disposeBag)
		
		
		
		input.goSignUpButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.destination.accept(.signUp)
			})
			.disposed(by: disposeBag)
		
		input.forgetIDBtnTapped
			.withUnretained(self)
            .observe(on: MainScheduler.instance)
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
