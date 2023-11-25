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
		/// SignIn이 AuthHome의 역할
	}
	
	// MARK: - Need To Initializing
	var disposeBag: DisposeBag
	var navigationController: UINavigationController
	
	// MARK: - Don't Need To Initializing
	var childCoordinators: [CoordinatorType] = []
	var delegate: CoordinatorDelegate?
	var userActionState: PublishRelay<AuthCoordinatorChild> = PublishRelay()
	weak var baseViewController: MainAuthViewController?
	
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
				case .signUp:
					if self.navigationController.viewControllers.contains(where: {$0 is SignUpViewController}) {
						self.popToRootViewController()
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
						popToRootViewController()
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
		let mainViewController = MainAuthViewController(
			viewModel: MainAuthViewModel(
				coordinator: self
			)
		)
		self.baseViewController = mainViewController
		self.pushViewController(viewController: mainViewController)
	}
	
	func popToRootViewController() {
		if let rootViewController = self.baseViewController {
			navigationController.popToViewController(rootViewController, animated: true)
		}
	}
}
