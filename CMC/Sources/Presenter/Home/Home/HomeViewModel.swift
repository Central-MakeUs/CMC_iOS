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
		
	}
	
	struct Output {
		let notificationsForBanner: Observable<[LatestNotificationsModel]>
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
		let notificationsObservable = notificationsUsecase.getLatestNotifications()
			.asObservable() // Convert Single to Observable
			.do(onNext: { [weak self] notifications in
				self?.notificationsDataUsecase.saveNotificationsData(notifications: notifications)
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
