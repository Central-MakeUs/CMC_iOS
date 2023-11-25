//
//  SendCertifyCodeView.swift
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

final class SendCertifyCodeView: BaseView {
	
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
		label.text = "가입하신 이메일을 인증해주시면\n비밀번호 재설정이 가능해요!"
		label.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
		label.numberOfLines = 2
		label.textColor = DesignSystemAsset.gray500.color
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var emailTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "이메일을 입력해주세요",
			textFieldSubTitle: "이메일",
			accessoryType: .none,
			keyboardType: .emailAddress
		)
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private lazy var receiveCertiftyButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.disabled),
			title: "인증번호 받기"
		)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	// MARK: - Properties
	private var viewModel: SendCertifyCodeViewModel
	private var parentViewModel: FindPasswordViewModel
	
	// MARK: - Initializers
	init(
		viewModel: SendCertifyCodeViewModel,
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
		addSubview(emailTextField)
		addSubview(receiveCertiftyButton)
	}
	
	override func setConstraint() {
		
		titleLabel.snp.makeConstraints{ titleLabel in
			titleLabel.top.equalToSuperview().offset(30)
			titleLabel.leading.equalToSuperview().offset(24)
		}
		
		subTitle.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(14)
			$0.leading.equalToSuperview().offset(24)
		}
		
		emailTextField.snp.makeConstraints {
			$0.top.equalTo(subTitle.snp.bottom).offset(30)
			$0.leading.equalToSuperview().offset(24)
			$0.trailing.equalToSuperview().offset(-24)
			$0.height.equalTo(74)
		}
		
		receiveCertiftyButton.snp.makeConstraints{ receiveCertiftyButton in
			receiveCertiftyButton.leading.trailing.equalToSuperview().inset(20)
			receiveCertiftyButton.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-20)
			receiveCertiftyButton.height.equalTo(56)
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
		
		let input = SendCertifyCodeViewModel.Input(
			email: emailTextField.rx.text.orEmpty.asObservable(),
			receiveCertifyTapped: receiveCertiftyButton.rx.tap.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.emailValidation
		.withUnretained(self)
		.subscribe(onNext: { owner, isEnable in
			isEnable == true
			? owner.receiveCertiftyButton.rxType.accept(.login(.inactive))
			: owner.receiveCertiftyButton.rxType.accept(.login(.disabled))
		})
		.disposed(by: disposeBag)
		
		output.sendCertifyResult
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] isSuccessed in
				guard let ss = self else { return }
				if isSuccessed {
					ss.parentViewModel.nowPage.accept(2)
					CMCBottomSheetManager.shared.showBottomSheet(
						title: "인증번호를 전송했어요",
						body: "3분 내 인증번호를 입력해주세요 :)",
						buttonTitle: "확인"
					)
				} else {
					CMCBottomSheetManager.shared.showBottomSheet(
						title: "존재하지 않는 계정이에요",
						body: "아이디 찾기는 운영진에게 문의해주세요 :)",
						buttonTitle: "확인"
					)
				}
			})
			.disposed(by: disposeBag)
		
	}
}

extension SendCertifyCodeView {
	fileprivate func isPointInsideTextField(_ point: CGPoint) -> Bool {
			// 모든 텍스트 필드를 순회하면서 탭된 위치가 텍스트 필드 내부인지 확인합니다.
			let textFields = [emailTextField]
			return textFields.contains(where: { $0.frame.contains(point) })
	}
}
