//
//  MyPageViewModel.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class MyPageViewModel: ViewModelType{
	
	struct Input {
		let backBtnTapped: Observable<Void>
		let myInfoBtnTapped: Observable<Void>
        let changePasswordBtnTapped: Observable<Void>
		let isLogoutTapped: Observable<Bool>
		let isAuthOutTapped: Observable<Bool>
	}
	
	struct Output {

	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	private let authDataUsecase: AuthDataUsecase
	private let userUsecase: UserUsecase
	
	init(
		userUsecase: UserUsecase,
		coordinator: HomeCoordinator
	) {
		self.userUsecase = userUsecase
		self.coordinator = coordinator
		self.authDataUsecase = DefaultAuthDataUsecase()
	}
	
	
	func transform(input: Input) -> Output {
		input.backBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		input.myInfoBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				let myInfoViewController = MyInfoViewController(
					viewModel: MyInfoViewModel(
						coordinator: owner.coordinator
					)
				)
				owner.coordinator?.pushViewController(viewController: myInfoViewController, animated: true)
			})
			.disposed(by: disposeBag)
        
        input.changePasswordBtnTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let findPasswordViewcontroller = FindPasswordViewController(
                    viewModel: FindPasswordViewModel(
                        coordinator: owner.coordinator,
                        authUsecase: DefaultAuthUsecase(
                            authRepository: DefaultAuthRepository()
                        )
                    )
                )
                owner.coordinator?.pushViewController(viewController: findPasswordViewcontroller, animated: true)
            })
            .disposed(by: disposeBag)
		
		input.isLogoutTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, isLogout in
				if isLogout {
					owner.authDataUsecase.deleteAuthData()
					owner.coordinator?.finish()
				}
			})
			.disposed(by: disposeBag)
		
		input.isAuthOutTapped
			.withUnretained(self)
			.flatMapLatest { owner, isDelete -> Observable<DeleteUserModel> in
				if isDelete {
					return owner.userUsecase.deleteUser()
						.observe(on: MainScheduler.instance)
						.asObservable()
						.catch { error -> Observable<DeleteUserModel> in
							guard let customError = error as? NetworkError else { throw error }
							CMCToastManager.shared.addToast(message: customError.errorDescription)
							return .empty()
						}
				} else {
					return .empty()
				}
			}
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] _ in
				guard let ss = self else { return }
				let deleteUserCompletedViewController = DeleteUserCompletedViewController(
					viewModel: DeleteUserCompletedViewModel(
						coordinator: ss.coordinator
					)
				)
				ss.coordinator?.presentViewController(
					viewController: deleteUserCompletedViewController,
					style: .overFullScreen
				)
			})
			.disposed(by: disposeBag)
		
		
		return Output(
			
		)
	}
	
}
