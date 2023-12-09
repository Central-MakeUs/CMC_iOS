//
//  AttendanceCompletedViewModel.swift
//  CMC
//
//  Created by Siri on 12/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class AttendanceCompletedViewModel: ViewModelType {
	
	struct Input {
		let completedBtnTapped: Observable<Void>
	}
	
	struct Output {
		
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	weak var coordinator: HomeCoordinator?
	
	// MARK: - Initializers
	init(
		coordinator: HomeCoordinator?
	) {
		self.coordinator = coordinator
	}
	
	func transform(input: Input) -> Output {
		input.completedBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.dismissViewController {
					owner.coordinator?.popToRootViewController(animated: true)
				}
			})
			.disposed(by: disposeBag)
		
		return Output()
	}
	
}
