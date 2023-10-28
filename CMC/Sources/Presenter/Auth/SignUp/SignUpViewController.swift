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
	
	private lazy var termsAndConditionsView: UIView = {
		let view = UIView()
		view.backgroundColor = .blue
		return view
	}()
	
	private lazy var emailCheckView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
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
			emailCheckView,
			completeSignUpView
		])
		return progressPager
	}()
	
	private lazy var nextButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type:	.login(.inactive),
			title: "다음"
		)
		return button
	}()
	
	// MARK: - Properties
	
	// MARK: - Initializers
	
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
			cmcPager.leading.trailing.equalToSuperview()
			cmcPager.bottom.equalToSuperview()
		}
		
		nextButton.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(56)
		}
	}
	
	override func bind() {
		nextButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.cmcPager.nextPage()
			})
			.disposed(by: disposeBag)
		
		cmcPager.getCurrentPage()
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, page in
				owner.navigationBar.accessoryLabel.text = "\(page)/\(owner.cmcPager.totalPages())"
			})
			.disposed(by: disposeBag)
		
		navigationBar.backButton.rx.tapped()
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.cmcPager.previousPage()
			})
			.disposed(by: disposeBag)
	}
	
}
