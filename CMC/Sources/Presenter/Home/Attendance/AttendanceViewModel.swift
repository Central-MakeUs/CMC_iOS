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
		let selfEnterQRCodeTapped: Observable<Void>
		let qrScanResult: Observable<QRCodeState>
		
	}
	
	struct Output {
		let qrCode: Observable<String>
		let needToRestartQRScan: Observable<Void>
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
		let needToRestartQRScan = PublishRelay<Void>()
		
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
			.flatMapLatest { owner, qrcode -> Single<AttendanceResultModel> in
				let body = PostAttendancesBody(code: qrcode)
				return owner.attendanceUsecase.postAttendances(body: body)
			}
			.asObservable()
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, result in
				let attendanceCompletedViewController = AttendanceCompletedViewController(
					viewModel: AttendanceCompletedViewModel(
						coordinator: owner.coordinator
					)
				)
				owner.coordinator?.presentViewController(
					viewController: attendanceCompletedViewController,
					style: .overFullScreen
				)
			}, onError: { error in
				guard let error = error as? NetworkError else { return }
				CMCToastManager.shared.addToast(message: error.errorDescription)
				needToRestartQRScan.accept(())
			})
			.disposed(by: disposeBag)
		
		input.backBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.popToRootViewController(animated: true)
			})
			.disposed(by: disposeBag)
		
		input.selfEnterQRCodeTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				let selfEnterQRCodeViewController = SelfEnterQRCodeViewController(
					viewModel: SelfEnterQRCodeViewModel(
						attendanceUsecase: DefaultAttendancesUsecase(
							attendancesRepository: DefaultAttendancesRepository()
						),
						coordinator: self.coordinator
					)
				)
				owner.coordinator?.pushViewController(viewController: selfEnterQRCodeViewController, animated: true)
			})
			.disposed(by: disposeBag)
		
		
		return Output(
			qrCode: qrCode,
			needToRestartQRScan: needToRestartQRScan.asObservable()
		)
	}
	
}
