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
		let qrCode: Observable<String>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	
	init(
		coordinator: HomeCoordinator?
	) {
		self.coordinator = coordinator
	}
	
	
	func transform(input: Input) -> Output {
		
		
		let qrCode = input.qrScanResult
			.withUnretained(self)
			.flatMap { owner, result -> Observable<String> in
				switch result {
				case .success(let qr):
					return .just(qr)
				case .fail:
					return .error(NetworkError.customError(code: "404", message: "카메라 인식에 실패하였습니다."))
				}
			}
			.asObservable()
		
		qrCode
			.withUnretained(self)
			.subscribe(onNext: { owner, qrcode in
				print("성공한 qrCode: \(qrcode)")
				let attendanceCompletedViewController = AttendanceCompletedViewController(
					viewModel: AttendanceCompletedViewModel(
						coordinator: owner.coordinator
					)
				)
				owner.coordinator?.presentViewController(
					viewController: attendanceCompletedViewController,
					style: .overFullScreen
				)
			})
			.disposed(by: disposeBag)
		
		input.backBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		
		
		return Output(
			qrCode: qrCode
		)
	}
	
}
