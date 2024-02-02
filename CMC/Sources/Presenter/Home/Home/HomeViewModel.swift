//
//  HomeViewModel.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class HomeViewModel: ViewModelType{
	
	struct Input {
		let settingButtonTapped: Observable<Void>
		let attendanceBtnTapped: Observable<Void>
		let checkAttendanceBtnTapped: Observable<Void>
	}
	
	struct Output {
		let notificationsForBanner: Observable<[AllNotificationsModel]>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	weak var coordinator: HomeCoordinator?
	private let notificationsUsecase: NotificationsUsecase
	
	private let notificationsDataUsecase = DefaultNotificationsDataUsecase()
	
	init(
		coordinator: HomeCoordinator,
		notificationsUsecase: NotificationsUsecase
	) {
		self.coordinator = coordinator
		self.notificationsUsecase = notificationsUsecase
	}
	
	
	func transform(input: Input) -> Output {
		
		input.settingButtonTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.destination.accept(.myPage)
			})
			.disposed(by: disposeBag)
		
        /*
		input.attendanceBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.destination.accept(.attendance)
			})
			.disposed(by: disposeBag)
		*/
        input.attendanceBtnTapped
            .flatMapLatest { _ in
                PrivacyManager.shared.requestPermission()
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, granted in
                if granted {
                    owner.coordinator?.destination.accept(.attendance)
                } else {
                    let alert = PrivacyManager.shared.goToSettingsAlert()
                    owner.coordinator?.presentViewController(viewController: alert, style: .automatic)
                }
            })
            .disposed(by: disposeBag)
		
		input.checkAttendanceBtnTapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.coordinator?.destination.accept(.checkMyAttendance)
			})
			.disposed(by: disposeBag)
		
		let notificationsObservable = notificationsUsecase.getAllNotifications()
			.asObservable()
            .debug()
            .observe(on: MainScheduler.instance)
			.do(onNext: { _ in
				
			}, onError: { error in
				CMCBottomSheetManager.shared.showBottomSheet(
					title: "공지 내용을 불러오는데 실패하였습니다.",
					body: "\(error.localizedDescription)",
					buttonTitle: "확인"
				)
			})
			.share(replay: 1, scope: .whileConnected) // To avoid multiple API calls if there are multiple subscribers
		
		return Output(
			notificationsForBanner: notificationsObservable
		)
	}
	
}
