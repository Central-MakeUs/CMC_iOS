//
//  SignUpCompletedViewController.swift
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

class SignUpCompletedViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var signUpCompletedLabel: UILabel = {
		let label = UILabel()
		label.text = "회원가입 신청이\n완료되었어요!"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = CMCAsset.gray50.color
		label.numberOfLines = 2
		return label
	}()
	
	private lazy var signUpCompletedSubLabel: UILabel = {
		let label = UILabel()
		label.text = "신청이 수락될 때까지 조금만 기다려주세요 :)"
		label.font = CMCFontFamily.Pretendard.medium.font(size: 14)
		label.textColor = CMCAsset.gray700.color
		return label
	}()
	
	private lazy var signUpCompletedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.signUpCompleted.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var completedButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			type: .login(.inactive),
			title: "확인"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: SignUpCompletedViewModel
	
	// MARK: - Initializers
	init(
		viewModel: SignUpCompletedViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	
	override func setAddSubView() {
		self.view.addSubview(self.signUpCompletedLabel)
		self.view.addSubview(self.signUpCompletedSubLabel)
		self.view.addSubview(self.signUpCompletedImageView)
		self.view.addSubview(self.completedButton)
	}
	
	override func setConstraint() {
		self.signUpCompletedLabel.snp.makeConstraints { make in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
			make.leading.equalToSuperview().offset(24)
		}
		
		self.signUpCompletedSubLabel.snp.makeConstraints { make in
			make.top.equalTo(self.signUpCompletedLabel.snp.bottom).offset(15)
			make.leading.equalTo(self.signUpCompletedLabel.snp.leading)
		}
		
		self.signUpCompletedImageView.snp.makeConstraints { make in
			make.top.equalTo(self.signUpCompletedSubLabel.snp.bottom).offset(40)
			make.centerX.equalToSuperview()
			make.width.equalTo(200)
			make.height.equalTo(200)
		}
		
		self.completedButton.snp.makeConstraints { make in
			make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(56)
		}
	}
	
	override func bind() {
		let input = SignUpCompletedViewModel.Input(completedBtnTapped: completedButton.rx.tap.asObservable())
		let _ = viewModel.transform(input: input)
	}
	
}
