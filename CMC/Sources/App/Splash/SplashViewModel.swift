//
//  SplashViewModel.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SplashViewModel: ViewModelType{
	
	struct Input {}
	
	struct Output {}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AppCoordinator?
	
	private let launchUsecase: LaunchUsecase
	private let authUsecase: AuthUsecase
	private let userUsecase: UserUsecase
	
	init(
		coordinator: AppCoordinator,
		launchUsecase: LaunchUsecase,
		authUsecase: AuthUsecase,
		userUsecase: UserUsecase
	) {
		self.coordinator = coordinator
		self.launchUsecase = launchUsecase
		self.authUsecase = authUsecase
		self.userUsecase = userUsecase
	}
	
	func transform(input: Input) -> Output {
		
		let apiCheck = launchUsecase.health()
			.asObservable()
			.map { result -> Bool in
				return true
			}
			.catchAndReturn(false)
		
		let accssToken = authUsecase.refresh()
			.asObservable()
			.map { result -> Bool in
				UserDefaultManager.shared.save(result.accessToken, for: .accessToken)
				return true
			}
			.catchAndReturn(false)
		
		
		Observable.zip(
			apiCheck.asObservable(),
			accssToken.asObservable()
		)
		.subscribe(onNext: { apiCheckResult, _ in
			if apiCheckResult {
				self.coordinator?.userActionState.accept(.home)
			} else {
				self.coordinator?.userActionState.accept(.auth)
				CMCBottomSheetManager.shared.showBottomSheet(
					title: "자동 로그인에 실패하였습니다.",
					body: "다시 로그인을 시도해주세요.",
					buttonTitle: "확인"
				)
			}
		}, onError: { error in
			self.coordinator?.userActionState.accept(.auth)
			CMCBottomSheetManager.shared.showBottomSheet(
				title: "오류가 발생하였습니다.",
				body: "\(error.localizedDescription)",
				buttonTitle: "확인"
			)
		}).disposed(by: disposeBag)
		return Output()
	}
}
