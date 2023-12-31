//
//  AuthCoordinator.swift
//  CMC
//
//  Created by Siri on 10/25/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AuthCoordinator: CoordinatorType {
	// MARK: - Navigation DEPTH 1 -
	enum AuthCoordinatorChild{
		case signUp
		case signIn
	}
	
	// MARK: - Need To Initializing
	var disposeBag: DisposeBag
	var navigationController: UINavigationController
	
	// MARK: - Don't Need To Initializing
	var childCoordinators: [CoordinatorType] = []
	var delegate: CoordinatorDelegate?
	var destination: PublishRelay<AuthCoordinatorChild> = PublishRelay()
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
				case .signUp:
					CMCIndecatorManager.shared.show()
					self.popToRootViewController(animated: true)
					let signUpViewController = SignUpViewController(
						viewModel: SignUpViewModel(
							coordinator: self,
							authUsecase: DefaultAuthUsecase(
								authRepository: DefaultAuthRepository()
							)
						)
					)
					self.pushViewController(viewController: signUpViewController, animated: true)
				case .signIn:
					CMCIndecatorManager.shared.show()
					self.popToRootViewController(animated: true)
					let signInViewController = SignInViewController(
						viewModel: SignInViewModel(
							coordinator: self,
							authUsecase: DefaultAuthUsecase(
								authRepository: DefaultAuthRepository()
							),
							userUsecase: DefaultUserUsecase(
								userRepository: DefaultUserRepository()
							)
						)
					)
					self.pushViewController(viewController: signInViewController, animated: true)
				}
			}).disposed(by: disposeBag)
	}
	
	func start() {
		let authViewController = AuthViewController(
			viewModel: AuthViewModel(
				coordinator: self
			)
		)
		self.baseViewController = authViewController
		self.pushViewController(viewController: authViewController, animated: false)
	}
}
