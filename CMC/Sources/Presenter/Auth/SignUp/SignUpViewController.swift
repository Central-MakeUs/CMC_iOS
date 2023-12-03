//
//  SignUpViewController.swift
//  CMC
//
//  Created by Siri on 10/26/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import SafariServices
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
			viewModel: MainSignUpViewModel(
				authUsecase: DefaultAuthUsecase(
					authRepository: DefaultAuthRepository()
				)
			),
			parentViewModel: viewModel
		)
		return view
	}()
	
	private lazy var completeSignUpView: UIView = {
		let view = CompletedSignUpView(
			viewModel: CompletedSignUpViewModel(),
			parentViewModel: viewModel
		)
		return view
	}()
	
	private lazy var cmcPager: CMCProgressPager = {
		let progressPager = CMCProgressPager(
			pages: [
				termsAndConditionsView,
				mainSignUpView,
				completeSignUpView
			],
			titles: [
				"약관동의",
				"가입 정보를 입력해주세요",
				"CMC 정보를 입력해주세요"
			]
		)
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
		
		nextButton.snp.makeConstraints{ nextButton in
			nextButton.leading.trailing.equalToSuperview().inset(20)
			nextButton.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-20)
			nextButton.height.equalTo(56)
		}
		
		cmcPager.snp.makeConstraints{ cmcPager in
			cmcPager.top.equalTo(navigationBar.snp.bottom)
			cmcPager.leading.trailing.equalToSuperview()
			cmcPager.bottom.equalTo(nextButton.snp.top).offset(-12)
		}
		
	}
	
	override func bind() {
		
		termsAndConditionsView.termsAndCondUrls
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, url in
				guard let url = URL(string: url) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
		nextButton.rx.tap
			.withLatestFrom(cmcPager.getCurrentPage())
			.withUnretained(self)
			.subscribe(onNext: { owner, nowPage in
				if nowPage != owner.cmcPager.totalPages() {
					owner.cmcPager.nextPage()
				}
				owner.view.endEditing(true)
			})
			.disposed(by: disposeBag)
		
		let input = SignUpViewModel.Input(
			backButtonTapped: navigationBar.backButton.rx.tapped().asObservable(),
			nextButtonTapped: nextButton.rx.tap.asObservable(),
			nowPage: cmcPager.getCurrentPage(),
			totalPage: cmcPager.totalPages()
		)
		
		let output = viewModel.transform(input: input)
		
		output.readyForNextButton
			.withUnretained(self)
			.subscribe(onNext: { owner, isActive in
				isActive
				? owner.nextButton.makeCustomState(type: .login(.inactive))
				: owner.nextButton.makeCustomState(type: .login(.disabled))
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
				owner.view.endEditing(true)
			})
			.disposed(by: disposeBag)
	}
	
}
