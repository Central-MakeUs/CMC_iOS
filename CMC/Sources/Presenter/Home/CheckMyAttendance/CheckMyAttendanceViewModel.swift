//
//  CheckMyAttendanceViewModel.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

class CheckMyAttendanceViewModel: ViewModelType {
		
		struct Input {
			let backBtnTapped: Observable<Void>
		}
		
		struct Output {
				let eventList: Observable<[CSEventListModel]>
				let matchDetail: Observable<[MatchDetailsModel]>
		}
		
		// MARK: - Properties
		let disposeBag = DisposeBag()
		let usecase: OverlayUsecase
		
		// MARK: - Initialize
		init(
				usecase: OverlayUsecase
		) {
				self.usecase = usecase
		}
		
		// MARK: - Methods
		func transform(input: Input) -> Output {
				
				let eventList = usecase.getMatchDatas()
						.asObservable()
						.catchAndReturn([])
						.share()
				
				let matchDetail = input.matchUid
						.flatMap { [weak self] matchUid -> Observable<[MatchDetailsModel]> in
								guard let self = self else { return .empty() }
								let query = SelectedMatchQuery(matchUid: matchUid)
								return self.usecase.getMatchDetails(query: query)
										.asObservable()
										.catchAndReturn([])
						}
						.share()
				
				return Output(
						eventList: eventList,
						matchDetail: matchDetail
				)
		}
		
}
