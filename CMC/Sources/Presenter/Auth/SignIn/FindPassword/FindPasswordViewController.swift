//
//  FindPasswordViewController.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class FindPasswordViewController: BaseViewController {
	
	// MARK: - UI
	
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: false
		)
		navigationBar.accessoryLabel.text = ""
		navigationBar.translatesAutoresizingMaskIntoConstraints = false
		return navigationBar
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "비밀번호 재설정"
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = DesignSystemAsset.gray50.color
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var emailView: SendCertifyCodeView = {
		let view = SendCertifyCodeView(
			viewModel: SendCertifyCodeViewModel(),
			parentViewModel: viewModel
		)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var certifyNumberView: ConfirmCertifyCodeView = {
		let view = ConfirmCertifyCodeView(
			viewModel: ConfirmCertifyCodeViewModel(
				usecase: DefaultAuthUsecase(
					authRepository: DefaultAuthRepository()
				),
				parentViewModel: viewModel
			)
		)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var resettingPasswordView: UIView = {
		let view = UIView()
		view.backgroundColor = .yellow
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var reSettingPasswordPager: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.bounces = false
		scrollView.isScrollEnabled = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
	private lazy var nextButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.inactive),
			title: "인증번호 전송하기"
		)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: FindPasswordViewModel
	private let nowPage = BehaviorRelay<Int>(value: 1)
	private let nextButtonTitles: [String] = [
		"인증번호 전송하기",
		"인증번호 확인하기",
		"비밀번호 재설정"
	]
	
	private var contentOffset: Double = 0
	// MARK: - Initializers
	init(
		viewModel: FindPasswordViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		for (index, page) in [emailView, certifyNumberView, resettingPasswordView].enumerated() {
			reSettingPasswordPager.addSubview(page)
			page.snp.makeConstraints { make in
				make.top.equalTo(titleLabel.snp.bottom).offset(14)
				make.bottom.equalTo(nextButton.snp.top).offset(-12)
				make.width.equalTo(self.view.frame.size.width)
				make.leading.equalToSuperview().offset(CGFloat(index) * self.view.frame.size.width)
			}
		}
		reSettingPasswordPager.contentSize = CGSize(
			width: self.view.frame.size.width * CGFloat(3),
			height: reSettingPasswordPager.frame.size.height
		)
	}
	// MARK: - Methods
	
	
	override func setAddSubView() {
		self.view.addSubview(navigationBar)
		self.view.addSubview(titleLabel)
		self.view.addSubview(reSettingPasswordPager)
		self.view.addSubview(nextButton)
		
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(68)
		}
		
		titleLabel.snp.makeConstraints{ titleLabel in
			titleLabel.top.equalTo(navigationBar.snp.bottom).offset(30)
			titleLabel.leading.equalToSuperview().offset(24)
		}
		
		nextButton.snp.makeConstraints{ nextButton in
			nextButton.leading.trailing.equalToSuperview().inset(20)
			nextButton.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-20)
			nextButton.height.equalTo(56)
		}
		
		reSettingPasswordPager.snp.makeConstraints{ cmcPager in
			cmcPager.top.equalTo(titleLabel.snp.bottom).offset(14)
			cmcPager.leading.trailing.equalToSuperview()
			cmcPager.bottom.equalTo(nextButton.snp.top).offset(-12)
		}
		
	}
	
	override func bind() {
		
		nextButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				let page = owner.nowPage.value + 1
				owner.nowPage.accept(page)
				owner.view.endEditing(true)
			})
			.disposed(by: disposeBag)
		
		nowPage.asObservable()
			.subscribe(onNext: { [weak self] page in
				guard let self = self else { return }
				let xOffset = CGFloat(page - 1) * CGFloat(self.view.frame.width)
				self.reSettingPasswordPager.setContentOffset(
					CGPoint(x: xOffset, y: 0), animated: true
				)
				let title = self.nextButtonTitles[page]
				self.nextButton.setTitle(title: title)
			})
			.disposed(by: disposeBag)
		
		let input = FindPasswordViewModel.Input(
			backButtonTapped: navigationBar.backButton.rx.tapped().asObservable(),
			nextButtonTapped: nextButton.rx.tap.asObservable(),
			nowPage: nowPage.asObservable()
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
		
	}
	
}
