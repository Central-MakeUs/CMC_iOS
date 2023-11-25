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
	var navigationController: UINavigationController
	
	// MARK: - Don't Need To Initializing
	var childCoordinators: [CoordinatorType] = []
	var delegate: CoordinatorDelegate?
	var userActionState: PublishRelay<AppCoordinatorChild> = PublishRelay()
	weak var baseViewController: UIViewController?
	
	init(
		navigationController: UINavigationController
	) {
		self.navigationController = navigationController
		self.disposeBag = DisposeBag()
		self.setState()
	}
	
	func setState(){
		self.userActionState
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				switch state{
				case .auth:
					let authCoordinator = AuthCoordinator(
						navigationController: owner.navigationController
					)
					authCoordinator.delegate = owner
					authCoordinator.start()
					owner.childCoordinators.append(authCoordinator)
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
		self.baseViewController = splashViewController
		self.pushViewController(viewController: splashViewController, animated: false)
	}
}

extension AppCoordinator: CoordinatorDelegate{
	func didFinish(childCoordinator: CoordinatorType) {
		self.childCoordinators.removeAll()
		if childCoordinator is AuthCoordinator {
			self.userActionState.accept(.tabBar)
		} else {
			self.userActionState.accept(.auth)
		}
	}
}
