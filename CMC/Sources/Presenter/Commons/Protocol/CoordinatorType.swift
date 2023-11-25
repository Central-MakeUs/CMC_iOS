//
//  CoordinatorType.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol CoordinatorDelegate: AnyObject {
	func didFinish(childCoordinator: CoordinatorType)
}

protocol CoordinatorType: AnyObject{
	var disposeBag: DisposeBag { get }
	var navigationController: UINavigationController {get set}
	
	var childCoordinators: [CoordinatorType] {get set}
	var delegate: CoordinatorDelegate? {get set}
	var baseViewController: UIViewController? { get set }
	
	func setState()
	func start()
	func finish()
	func popToRootViewController(animated: Bool)
	
	// MARK: Navigation 동작
	func pushViewController(viewController vc: UIViewController, animated: Bool )
	func popViewController(animated: Bool)
	
	// MARK: Modal 동작
	func presentViewController(viewController vc: UIViewController, style: UIModalPresentationStyle )
	func dismissViewController(completion: (() -> Void)?)
	
}

extension CoordinatorType{
	
	/// finish가 호출되면 -> delegate를 self로 할당하면서 didFinish를 정의한놈의 child를 모두 지워줌
	func finish() {
		childCoordinators.removeAll()
		delegate?.didFinish(childCoordinator: self)
	}
	
	func pushViewController(viewController vc: UIViewController, animated: Bool ){
		self.navigationController.setNavigationBarHidden(true, animated: false)
		self.navigationController.pushViewController(vc, animated: animated)
	}
	
	func popViewController(animated: Bool) {
		self.navigationController.popViewController(animated: animated)
	}
	
	func presentViewController(viewController vc: UIViewController, style: UIModalPresentationStyle){
		vc.modalPresentationStyle = style
		self.navigationController.present(vc, animated: true)
	}
	
	func dismissViewController(completion: (() -> Void)?) {
		navigationController.dismiss(animated: true, completion: completion)
	}
	
	func popToRootViewController(animated: Bool) {
		if let rootViewController = self.baseViewController {
			navigationController.popToViewController(rootViewController, animated: animated)
		}
	}
	
}
