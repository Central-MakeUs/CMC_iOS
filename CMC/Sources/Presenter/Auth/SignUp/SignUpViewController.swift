//
//  SignUpViewController.swift
//  CMC
//
//  Created by Siri on 10/26/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class SignUpViewController: BaseViewController {
	
	// MARK: - UI
	
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: false
		)
		navigationBar.accessoryLabel.text = ""
		return navigationBar
	}()
	
	private lazy var termsAndConditionsView: TermsAndConditionsView = {
		let view = TermsAndConditionsView(
			viewModel: TermsAndConditionsViewModel(),
			parentViewModel: viewModel
		)
		return view
	}()
	
	private lazy var mainSignUpView: MainSignUpView = {
		let view = MainSignUpView(
			viewModel: MainSignUpViewModel(),
			parentViewModel: viewModel
		)
		return view
	}()
	
	private lazy var completeSignUpView: UIView = {
		let view = UIView()
		view.backgroundColor = .yellow
		return view
	}()
	
	private lazy var cmcPager: CMCProgressPager = {
		let progressPager = CMCProgressPager(pages: [
			termsAndConditionsView,
			mainSignUpView,
			completeSignUpView
		])
		return progressPager
	}()
	
	private lazy var nextButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.disabled),
			title: "다음"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: SignUpViewModel
	
	// MARK: - Initializers
	init(
		viewModel: SignUpViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	
	override func setAddSubView() {
		self.view.addSubview(navigationBar)
		self.view.addSubview(cmcPager)
		self.view.addSubview(nextButton)
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(68)
		}
		
		cmcPager.snp.makeConstraints{ cmcPager in
			cmcPager.top.equalTo(navigationBar.snp.bottom)
			cmcPager.leading.trailing.bottom.equalToSuperview()
		}
		
		nextButton.snp.makeConstraints{ nextButton in
			nextButton.leading.trailing.equalToSuperview().inset(20)
			nextButton.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
			nextButton.height.equalTo(56)
		}
		
	}
	
	override func bind() {
		
//		NotificationManager.shared.keyboardHeightSubject
//			.debug()
//			.observe(on: MainScheduler.instance)
//			.withUnretained(self)
//			.subscribe(onNext: { owner, keyboardHeight in
//				let realHeight = keyboardHeight > 0 ? keyboardHeight : 0
//				owner.cmcPager.snp.updateConstraints { make in
//					make.bottom.equalToSuperview().offset(-realHeight)
//				}
//				UIView.animate(withDuration: 0.3) {
//					owner.view.layoutIfNeeded()
//				}
//			})
//			.disposed(by: disposeBag)
		
		let input = SignUpViewModel.Input(
			backButtonTapped: navigationBar.backButton.rx.tapped().asObservable(),
			nextButtonTapped: nextButton.rx.tap.asObservable(),
			nowPage: cmcPager.getCurrentPage(),
			totalPage: cmcPager.totalPages()
		)
		
		let output = viewModel.transform(input: input)
		
		nextButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.cmcPager.nextPage()
			})
			.disposed(by: disposeBag)
		
		output.readyForNextButton
			.asObservable()
			.withUnretained(self)
			.subscribe(onNext: { owner, isActive in
				isActive
				? owner.nextButton.makeCustomState(type: .login(.inactive))
				: owner.nextButton.makeCustomState(type: .login(.disabled))
			})
			.disposed(by: disposeBag)
		
		output.backButtonHidden
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, hidden in
				owner.navigationBar.backButton.isHidden = hidden
			})
			.disposed(by: disposeBag)
		
		output.navigationAccessoryText
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, text in
				owner.navigationBar.accessoryLabel.text = text
			})
			.disposed(by: disposeBag)
		
		output.nextButtonTitle
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, title in
				owner.nextButton.setTitle(title: title)
			})
			.disposed(by: disposeBag)
	}
	
}
