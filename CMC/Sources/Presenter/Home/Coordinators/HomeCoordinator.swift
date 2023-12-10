//
//  HomeCoordinator.swift
//  CMC
//
//  Created by Siri on 11/26/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeCoordinator: CoordinatorType {
	// MARK: - Navigation DEPTH 1 -
	enum HomeCoordinatorChild{
		case attendance
		case checkMyAttendance
		case myPage
	}
	
	// MARK: - Need To Initializing
	var disposeBag: DisposeBag
	var navigationController: UINavigationController
	
	// MARK: - Don't Need To Initializing
	var childCoordinators: [CoordinatorType] = []
	var delegate: CoordinatorDelegate?
	var destination: PublishRelay<HomeCoordinatorChild> = PublishRelay()
	weak var baseViewController: UIViewController?
	
	init(
		navigationController: UINavigationController
	){
		self.navigationController = navigationController
		self.disposeBag = DisposeBag()
		self.setState()
	}
	
	func setState() {
		self.destination
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] state in
				guard let self = self else {return}
				switch state{
				case .attendance:
					CMCIndecatorManager.shared.show()
					self.popToRootViewController(animated: true)
					let attendanceViewController = AttendanceViewController(
						viewModel: AttendanceViewModel(
							attendanceUsecase: DefaultAttendancesUsecase(
								attendancesRepository: DefaultAttendancesRepository()
							),
							coordinator: self
						)
					)
					self.pushViewController(viewController: attendanceViewController, animated: true)
					print("🍎 여기는 출석QR이요~ 🍎")
				case .checkMyAttendance:
					CMCIndecatorManager.shared.show()
					self.popToRootViewController(animated: true)
					let checkMyAttendanceViewController = CheckMyAttendanceViewController(
						viewModel: CheckMyAttendanceViewModel(
							attendancesUsecase: DefaultAttendancesUsecase(
								attendancesRepository: DefaultAttendancesRepository()
							),
							coordinator: self
						)
					)
					self.pushViewController(viewController: checkMyAttendanceViewController, animated: true)
					print("🍎 여기는 출석 확인하기여~ 🍎")
				case .myPage:
					CMCIndecatorManager.shared.show()
					self.popToRootViewController(animated: true)
					let myPageViewController = MyPageViewController(
						viewModel: MyPageViewModel(
							coordinator: self
						)
					)
					self.pushViewController(viewController: myPageViewController, animated: true)
				}
			}).disposed(by: disposeBag)
	}
	
	func start() {
		let homeViewController = HomeViewController(
			viewModel: HomeViewModel(
				coordinator: self,
				notificationsUsecase: DefaultNotificationsUsecase(
					notificationsRepository: DefaultNotificationsRepository()
				)
			)
		)
		self.baseViewController = homeViewController
		self.pushViewController(viewController: homeViewController, animated: true)
	}
}
