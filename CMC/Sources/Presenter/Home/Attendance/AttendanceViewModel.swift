//
//  AttendanceViewModel.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class AttendanceViewModel: ViewModelType{
	
	struct Input {
		let backBtnTapped: Observable<Void>
		let qrScanResult: Observable<QRCodeState>
	}
	
	struct Output {
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	
	init(
		coordinator: HomeCoordinator?
	) {
		self.coordinator = coordinator
	}
	
	
	func transform(input: Input) -> Output {
		
		input.qrScanResult
			.withUnretained(self)
			.take(1)
			.subscribe(onNext: { owner, result in
				switch result {
				case .success(let qr):
					CMCBottomSheetManager.shared.showBottomSheet(
						title: "출석 확인",
						body: qr,
						buttonTitle: "테스트임"
					)
				case .fail:
					print("실패")
				}
			})
			.disposed(by: disposeBag)
		
		input.backBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		
		
		return Output(
		)
	}
	
}
