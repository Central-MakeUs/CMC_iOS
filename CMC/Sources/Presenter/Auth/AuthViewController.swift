//
//  AuthViewController.swift
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

class AuthViewController: BaseViewController {
	
	// MARK: - UI
	
	private lazy var backgroundImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.splash.image
		return imageView
	}()
	
	private lazy var mainTitle: UILabel = {
			let gradientLabel = GradientLabel()
			let text = "수익형 앱 런칭을 위한 최고의\nIT 연합 동아리"
			var paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineHeightMultiple = 1.26
			let attributeString = NSMutableAttributedString(
				string: text,
				attributes: [
					NSAttributedString.Key.paragraphStyle: paragraphStyle
				]
			)
			gradientLabel.attributedText = attributeString
			gradientLabel.gradientColors = [
					UIColor(hex: 0x615DFF).cgColor,
					UIColor(hex: 0xFFFFFF).cgColor
			]
			gradientLabel.numberOfLines = 0
			gradientLabel.textAlignment = .center
			gradientLabel.font = CMCFontFamily.Pretendard.bold.font(size: 24)
			gradientLabel.translatesAutoresizingMaskIntoConstraints = false
			return gradientLabel
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
	private let viewModel: AuthViewModel
	
	// MARK: - Initializers
	init(
		viewModel: AuthViewModel
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
		self.view.addSubview(mainTitle)
		self.view.addSubview(mainLogo)
		self.view.addSubview(signInButton)
		self.view.addSubview(signUpButton)
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
			make.centerX.equalToSuperview()
			make.height.equalTo(56)
			make.width.equalTo(self.view.frame.width - 48)
			make.top.equalTo(mainLogo.snp.bottom).offset(84)
		}
		
		signUpButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.height.equalTo(56)
			make.width.equalTo(self.view.frame.width - 48)
			make.top.equalTo(signInButton.snp.bottom).offset(28)
		}
		
	}
	
	override func bind() {
		let input = AuthViewModel.Input(
			signInBtnTapped: signInButton.rx.tap.asObservable(),
			signUpBtnTapped: signUpButton.rx.tap.asObservable()
		)
		
		let _ = viewModel.transform(input: input)
		
	}
}
