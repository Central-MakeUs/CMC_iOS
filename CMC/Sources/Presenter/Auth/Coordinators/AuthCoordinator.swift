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
		case main
		case signUp
		case signIn
		/// SignIn이 AuthHome의 역할
	}
	
	// MARK: - Need To Initializing
	var disposeBag: DisposeBag
	var navigationController: UINavigationController
	
	// MARK: - Don't Need To Initializing
	var childCoordinators: [CoordinatorType] = []
	var delegate: CoordinatorDelegate?
	var userActionState: PublishRelay<AuthCoordinatorChild> = PublishRelay()
	/// init에서만 호출하고, stream을 유지하기위해 BehaviorSubject 사용
	
	init(
		navigationController: UINavigationController
	){
		self.navigationController = navigationController
		self.disposeBag = DisposeBag()
		self.setState()
	}
	
	func setState() {
		self.userActionState
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] state in
				guard let self = self else {return}
				CMCIndecatorManager.shared.show()
				switch state{
				case .main:
					if self.navigationController.viewControllers.contains(where: {$0 is MainAuthViewController}) {
						self.navigationController.popToRootViewController(animated: true)
					}
					let mainAuthViewController = MainAuthViewController(
						viewModel: MainAuthViewModel(
							 coordinator: self
						 )
					 )
					 self.pushViewController(viewController: mainAuthViewController)
					CMCIndecatorManager.shared.hide()
				case .signUp:
					if self.navigationController.viewControllers.contains(where: {$0 is SignUpViewController}) {
						self.navigationController.popToRootViewController(animated: true)
					}
					let signUpViewController = SignUpViewController(
						viewModel: SignUpViewModel(
							 coordinator: self,
							 authUsecase: DefaultAuthUsecase(
								 authRepository: DefaultAuthRepository()
							 )
						 )
					 )
					 self.pushViewController(viewController: signUpViewController)
					CMCIndecatorManager.shared.hide()
				case .signIn:
					if self.navigationController.viewControllers.contains(where: {$0 is SignInViewController}) {
						self.navigationController.popToRootViewController(animated: true)
					}
					let signInViewController = SignInViewController(
						viewModel: SignInViewModel(
							coordinator: self,
							authUsecase: DefaultAuthUsecase(
								authRepository: DefaultAuthRepository()
							)
						)
					)
					self.pushViewController(viewController: signInViewController)
					CMCIndecatorManager.shared.hide()
				}
			}).disposed(by: disposeBag)
	}
	
	func start() {
		self.userActionState.accept(.main)
	}
	
}
