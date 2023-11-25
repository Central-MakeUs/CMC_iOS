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
	
	private lazy var emailView: SendCertifyCodeView = {
		let view = SendCertifyCodeView(
			viewModel: SendCertifyCodeViewModel(
				usecase: DefaultAuthUsecase(
					authRepository: DefaultAuthRepository()
				)
			),
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
				)
			),
			parentViewModel: viewModel
		)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var resettingPasswordView: ResettingPasswordView = {
		let view = ResettingPasswordView(
			viewModel: ResettingPasswordViewModel(),
			parentViewModel: viewModel
		)
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
	
	// MARK: - Properties
	private let viewModel: FindPasswordViewModel
	private let nowPage = BehaviorRelay<Int>(value: 1)
	
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
				make.top.equalTo(navigationBar.snp.bottom)
				make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
		self.view.addSubview(reSettingPasswordPager)
		
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(68)
		}
		
		reSettingPasswordPager.snp.makeConstraints{ cmcPager in
			cmcPager.top.equalTo(navigationBar.snp.bottom)
			cmcPager.leading.trailing.equalToSuperview()
			cmcPager.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
		}
		
	}
	
	override func bind() {
		
		
		let input = FindPasswordViewModel.Input(
			backButtonTapped: navigationBar.backButton.rx.tapped().asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		
		output.afterPage
			.subscribe(onNext: { [weak self] page in
				guard let self = self else { return }
				let xOffset = CGFloat(page - 1) * CGFloat(self.view.frame.width)
				self.reSettingPasswordPager.setContentOffset(
					CGPoint(x: xOffset, y: 0), animated: true
				)
			})
			.disposed(by: disposeBag)
		
	}
	
}
