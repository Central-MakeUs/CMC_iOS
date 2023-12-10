//
//  SelfEnterQRCodeViewModel.swift
//  CMC
//
//  Created by Siri on 12/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class SelfEnterQRCodeViewModel: ViewModelType{
	
	struct Input {
		let qrCode: Observable<String>
		let nextBtnTapped: Observable<Void>
		let backBtnTapped: Observable<Void>
	}
	
	struct Output {
		let qrCodeResult: Observable<(Bool, String)>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	private let attendanceUsecase: AttendancesUsecase
	
	init(
		attendanceUsecase: AttendancesUsecase,
		coordinator: HomeCoordinator?
	) {
		self.attendanceUsecase = attendanceUsecase
		self.coordinator = coordinator
	}
	
	
	func transform(input: Input) -> Output {
		let qrCodeResult = input.nextBtnTapped
			.withLatestFrom(input.qrCode)
			.withUnretained(self)
			.flatMap { owner, qrcode -> Observable<(Bool, String)> in
				let body = PostAttendancesBody(code: qrcode)
				return owner.attendanceUsecase.postAttendances(body: body)
					.asObservable()
					.map { (true, $0.message ) }
					.catch { error -> Observable<(Bool, String)> in
						let customError = (error as! NetworkError).errorDescription
						return .just((false, customError))
					}
			}
		
		qrCodeResult
			.subscribe(onNext: { valid, message in
				if valid {
					let attendanceCompletedViewController = AttendanceCompletedViewController(
						viewModel: AttendanceCompletedViewModel(
							coordinator: self.coordinator
						)
					)
					self.coordinator?.dismissViewController {
						self.coordinator?.presentViewController(
							viewController: attendanceCompletedViewController,
							style: .overFullScreen
						)
					}
				}
			})
			.disposed(by: disposeBag)
		
		/*
			.asObservable()
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { [weak self] qrCode in
				guard let self = self else { return }
				let attendanceCompletedViewController = AttendanceCompletedViewController(
					viewModel: AttendanceCompletedViewModel(
						coordinator: self.coordinator
					)
				)
				self.coordinator?.presentViewController(
					viewController: attendanceCompletedViewController,
					style: .overFullScreen
				)
			}, onError: { error in
				guard let customError = error as? NetworkError else { return }
				errorSubject.accept(customError)
				//TODO: - 텍스트 필드의 상태를 Error로 변경해줘야함
			})
			.disposed(by: disposeBag)
	*/
		input.backBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		
		
		
		return Output(
			qrCodeResult: qrCodeResult
		)
	}
	
}
