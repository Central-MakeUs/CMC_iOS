//
//  SignUpCompletedViewModel.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class SignUpCompletedViewModel: ViewModelType {
	
	struct Input {
		let completedBtnTapped: Observable<Void>
	}
	
	struct Output {
		
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: AuthCoordinator?
	
	// MARK: - Initializers
	init(
		coordinator: AuthCoordinator?
	) {
		self.coordinator = coordinator
	}
	
	func transform(input: Input) -> Output {
		input.completedBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.dismissViewController {
					owner.coordinator?.popViewController(animated: true)
				}
			})
			.disposed(by: disposeBag)
		
		return Output()
	}
	
}
