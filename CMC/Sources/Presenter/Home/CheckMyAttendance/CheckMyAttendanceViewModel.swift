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
		let attendanceAllStatus: Observable<AttendanceStatusModel>
		let attendanceDetails: Observable<[AttendanceDetailsModel]>
	}
	
	// MARK: - Properties
	let disposeBag = DisposeBag()
	let attendancesUsecase: AttendancesUsecase
	
	// MARK: - Initialize
	init(
		attendancesUsecase: AttendancesUsecase
	) {
		self.attendancesUsecase = attendancesUsecase
	}
	
	// MARK: - Methods
	func transform(input: Input) -> Output {
		let attendancesObservable = attendancesUsecase.getAttendances()
			.asObservable()
			.share()
		
		let attendanceAllStatus = attendancesObservable
			.map { $0.0 }  // 첫 번째 요소 (AttendanceStatusModel)
		
		let attendanceDetails = attendancesObservable
			.map { $0.1 }  // 두 번째 요소 ([AttendanceDetailsModel])
		
		return Output(
			attendanceAllStatus: attendanceAllStatus,
			attendanceDetails: attendanceDetails
		)
	}
	
}
