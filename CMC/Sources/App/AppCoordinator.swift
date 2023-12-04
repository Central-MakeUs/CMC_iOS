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
		case home
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
					CMCIndecatorManager.shared.show()
					let authCoordinator = AuthCoordinator(
						navigationController: owner.navigationController
					)
					authCoordinator.delegate = owner
					authCoordinator.start()
					owner.childCoordinators.append(authCoordinator)
				case .home:
					CMCIndecatorManager.shared.show()
					let homeCoordinator = HomeCoordinator(
						navigationController: owner.navigationController
					)
					homeCoordinator.delegate = owner
					homeCoordinator.start()
					owner.childCoordinators.append(homeCoordinator)
				}
			}).disposed(by: disposeBag)
	}
	
	func start() {
		let splashViewController = SplashViewController(
			viewModel: SplashViewModel(
				coordinator: self,
				launchUsecase: DefaultLaunchUsecase(
					launchRepository: DefaultLaunchRepository()
				),
				authUsecase: DefaultAuthUsecase(
					authRepository: DefaultAuthRepository()
				),
				userUsecase: DefaultUserUsecase(
					userRepository: DefaultUserRepository()
				)
			)
		)
		self.baseViewController = splashViewController
		self.pushViewController(viewController: splashViewController, animated: false)
	}
}

extension AppCoordinator: CoordinatorDelegate{
	func didFinish(childCoordinator: CoordinatorType) {
		self.popToRootViewController(animated: true)
		self.childCoordinators.removeAll()
		if childCoordinator is AuthCoordinator {
			self.userActionState.accept(.home)
		} else {
			self.userActionState.accept(.auth)
		}
	}
}
