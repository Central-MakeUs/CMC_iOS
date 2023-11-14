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
	
	init(
		coordinator: AppCoordinator,
		launchUsecase: LaunchUsecase
	) {
		self.coordinator = coordinator
		self.launchUsecase = launchUsecase
	}
	
	
	func transform(input: Input) -> Output {
		
		launchUsecase.health()
			.observe(on: MainScheduler.instance)
			.subscribe(
				onSuccess: { [weak self] message in
					self?.checkAutoSignIn()
				}, onFailure: { [weak self] error in
					self?.coordinator?.userActionState.accept(.auth)
					CMCToastManager.shared.addToast(message: error.localizedDescription)
				}).disposed(by: disposeBag)
		
		return Output()
	}
	
	private func checkAutoSignIn(){
		if let _: String = UserDefaultManager.shared.load(for: .accessToken) {
			self.coordinator?.userActionState.accept(.tabBar)
		} else {
			self.coordinator?.userActionState.accept(.auth)
		}
	}
}
