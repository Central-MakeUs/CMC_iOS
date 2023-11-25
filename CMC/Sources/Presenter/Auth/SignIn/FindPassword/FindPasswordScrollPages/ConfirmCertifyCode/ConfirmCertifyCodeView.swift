//
//  ConfirmCertifyCodeView.swift
//  CMC
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxGesture
import RxSwift

import DesignSystem
import SnapKit

import UIKit

final class ConfirmCertifyCodeView: BaseView {
	
	// MARK: - UI
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "비밀번호 재설정"
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = DesignSystemAsset.gray50.color
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var subTitle: UILabel = {
		let label = UILabel()
		label.text = "이메일로 인증번호를 전송했어요\n인증번호를 입력해주세요!"
		label.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
		label.numberOfLines = 2
		label.textColor = DesignSystemAsset.gray500.color
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var certifyCodeTextField: CMCTextField_Timer = {
		let textField = CMCTextField_Timer(
			placeHolder: "인증번호를 입력해주세요",
			textFieldSubTitle: "인증번호",
			buttonTitle: "재요청",
			keyboardType: .numberPad
		)
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	
	// MARK: - Properties
	private var viewModel: ConfirmCertifyCodeViewModel
	private var parentViewModel: FindPasswordViewModel
	
	// MARK: - Initializers
	init(
		viewModel: ConfirmCertifyCodeViewModel,
		parentViewModel: FindPasswordViewModel
	) {
		self.viewModel = viewModel
		self.parentViewModel = parentViewModel
		super.init(frame: .zero)
		self.backgroundColor = CMCAsset.background.color
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	// MARK: - Methods
	
	override func setAddSubView() {
		addSubview(titleLabel)
		addSubview(subTitle)
		addSubview(certifyCodeTextField)
	}
	
	override func setConstraint() {
		
		titleLabel.snp.makeConstraints{ titleLabel in
			titleLabel.top.equalToSuperview().offset(30)
			titleLabel.leading.equalToSuperview().offset(24)
		}
		
		subTitle.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(24)
			$0.leading.equalToSuperview().offset(24)
		}
		
		certifyCodeTextField.snp.makeConstraints {
			$0.top.equalTo(subTitle.snp.bottom).offset(30)
			$0.leading.equalToSuperview().offset(24)
			$0.trailing.equalToSuperview().offset(-24)
			$0.height.equalTo(74)
		}
		
	}
	
	override func bind() {
		
		self.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.subscribe(onNext: { owner, gesture in
				let location = gesture.location(in: owner)
				if !owner.isPointInsideTextField(location) {
					owner.endEditing(true)
				}
			})
			.disposed(by: disposeBag)
		
		
		let input = ConfirmCertifyCodeViewModel.Input(
			nowPage: parentViewModel.nowPage.asObservable(),
			certifiedCode: certifyCodeTextField.rx.text.orEmpty.asObservable(),
			reSendButtonTapped: certifyCodeTextField.accessoryCMCButton.rx.tap.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.startTimer
			.withUnretained(self)
			.subscribe(onNext: { owner, isStart in
				if isStart {
					owner.certifyCodeTextField.resetTimer()
				}
			})
			.disposed(by: disposeBag)
		
	}
}

extension ConfirmCertifyCodeView {
	fileprivate func isPointInsideTextField(_ point: CGPoint) -> Bool {
			// 모든 텍스트 필드를 순회하면서 탭된 위치가 텍스트 필드 내부인지 확인합니다.
			let textFields = [certifyCodeTextField]
			return textFields.contains(where: { $0.frame.contains(point) })
	}
}
