//
//  DeleteUserCompletedViewModel.swift
//  CMC
//
//  Created by Siri on 12/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class DeleteUserCompletedViewModel: ViewModelType {
	
	struct Input {
		let completedBtnTapped: Observable<Void>
	}
	
	struct Output {
		
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: HomeCoordinator?
	private let authDataUsecase: AuthDataUsecase
	private let userDataUsecase: UserDataUsecase
	
	// MARK: - Initializers
	init(
		coordinator: HomeCoordinator?
	) {
		self.coordinator = coordinator
		self.authDataUsecase = DefaultAuthDataUsecase()
		self.userDataUsecase = DefaultUserDataUsecase()
	}
	
	func transform(input: Input) -> Output {
		input.completedBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.dismissViewController {
					owner.authDataUsecase.deleteAuthData()
					owner.userDataUsecase.saveNoneUserData()
					owner.coordinator?.finish()
				}
			})
			.disposed(by: disposeBag)
		
		return Output()
	}
	
}
