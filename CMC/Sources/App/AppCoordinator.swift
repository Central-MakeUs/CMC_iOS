//
//  AppCoordinator.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxCocoa
import RxSwift

import UIKit

class AppCoordinator: CoordinatorType {

	// MARK: - Navigation DEPTH 0 -
	enum AppCoordinatorChild{
		case auth
		case tabBar
	}
	
	// MARK: - Need To Initializing
	var disposeBag: DisposeBag
	var userActionState: PublishRelay<AppCoordinatorChild> = PublishRelay()
	/// init에서만 호출하고, stream을 유지하기위해 BehaviorSubject 사용
	var navigationController: UINavigationController
	
	// MARK: - Don't Need To Initializing
	var childCoordinators: [CoordinatorType] = []
	var delegate: CoordinatorDelegate?
	
	init(
		navigationController: UINavigationController
	) {
		self.navigationController = navigationController
		self.disposeBag = DisposeBag()
		self.setState()
	}
	
	func setState(){
		self.userActionState
			.subscribe(onNext: { [weak self] state in
				guard let self = self else {return}
				switch state{
				case .auth:
					print("🍎 여기 들어가면, 메인 로그인 화면으로~ 🍎")
				case .tabBar:
					print("🍎 여기 들어가면, 메인 탭 화면으로~ 🍎")
				}
			}).disposed(by: disposeBag)
	}
	
	func start() {
		let splashViewController = SplashViewController(
			viewModel: SplashViewModel(
				coordinator: self,
				launchUsecase: DefaultLaunchUsecase(
					launchRepository: DefaultLaunchRepository()
				)
			)
		)
		self.pushViewController(viewController: splashViewController)
	}
}

extension AppCoordinator: CoordinatorDelegate{
	func didFinish(childCoordinator: CoordinatorType) {
//		self.navigationController.popViewController(animated: true)
//		if childCoordinator is AuthCoordinator {
//			self.userActionState.accept(.tabBar)
//		} else {
//			self.userActionState.accept(.auth)
//		}
		// 여기는 회원가입까지 끝나고 ㅎ
	}
}
