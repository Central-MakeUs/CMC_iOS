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
	}
	
	struct Output {

	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	
	init(
		coordinator: HomeCoordinator
	) {
		self.coordinator = coordinator
	}
	
	
	func transform(input: Input) -> Output {
		
		input.backBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popToRootViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		return Output(
			
		)
	}
	
}
