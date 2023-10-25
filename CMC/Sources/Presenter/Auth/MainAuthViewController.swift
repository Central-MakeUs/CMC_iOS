//
//  MainAuthViewController.swift
//  CMC
//
//  Created by Siri on 10/25/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class MainAuthViewController: BaseViewController {
	
	// MARK: - UI
	
	private lazy var backgroundImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.splash.image
		return imageView
	}()
	
	private lazy var mainTitle: UIImageView = {
		let label = UIImageView()
		label.image = CMCAsset.splashTitle.image
		return label
	}()
	
	private lazy var mainLogo: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.splashLogo.image
		return imageView
	}()
	
	private lazy var signInButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			type: .login(.inactive),
			title: "로그인"
		)
		return button
	}()
	
	private lazy var signUpButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			type: .login(.clear),
			title: "회원가입"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: MainAuthViewModel
	
	// MARK: - Initializers
	init(
		viewModel: MainAuthViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		self.view.addSubview(backgroundImageView)
		backgroundImageView.addSubview(mainTitle)
		backgroundImageView.addSubview(mainLogo)
		backgroundImageView.addSubview(signInButton)
		backgroundImageView.addSubview(signUpButton)
	}
	
	override func setConstraint() {
		backgroundImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		mainTitle.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(44)
			make.trailing.equalToSuperview().offset(-44)
			make.top.equalToSuperview().offset(180)
		}
		
		mainLogo.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(mainTitle.snp.bottom).offset(60)
			make.width.height.equalTo(108)
		}
		
		signInButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(56)
			make.top.equalTo(mainLogo.snp.bottom).offset(84)
		}
		
		signUpButton.snp.makeConstraints { make in
			make.leading.trailing.equalTo(signInButton)
			make.height.equalTo(56)
			make.top.equalTo(signInButton.snp.bottom).offset(28)
		}
		
	}
	
	override func bind() {
	}
}
