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
		let isLogoutTapped: Observable<Bool>
		let isAuthOutTapped: Observable<Bool>
	}
	
	struct Output {

	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	private let authDataUsecase: AuthDataUsecase
	
	init(
		coordinator: HomeCoordinator
	) {
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
			.subscribe(onNext: { owner, isAuthOut in
				if isAuthOut {
					CMCToastManager.shared.addToast(message: "테스트용: - 회원탈퇴 성공")
				} else {
					CMCToastManager.shared.addToast(message: "테스트용: - 회원탈퇴 실패")
				}
			})
			.disposed(by: disposeBag)
		
		
		return Output(
			
		)
	}
	
}
