//
//  ResettingPasswordView.swift
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

final class ResettingPasswordView: BaseView {
	// MARK: - UI
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isScrollEnabled = true
		return scrollView
	}()
	
	private lazy var mainContentView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "비밀번호 재설정"
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = DesignSystemAsset.gray50.color
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var passwordTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "비밀번호를 입력해주세요",
			textFieldSubTitle: "비밀번호",
			accessoryType: .image(image: CMCAsset._24x24hide.image),
			keyboardType: .default
		)
		textField.accessoryButton.setImage(CMCAsset._24x24show.image, for: .selected)
		return textField
	}()
	
	private lazy var passwordErrorCells: [CMCErrorMessage] = {
		let errorCell: [CMCErrorMessage] = [
			CMCErrorMessage(title: "영문", type: .disabled),
			CMCErrorMessage(title: "숫자", type: .disabled),
			CMCErrorMessage(title: "8자~16자", type: .disabled)
		]
		return errorCell
	}()
	
	private lazy var passwordErrorStackView: UIStackView = {
		let stackView = UIStackView(
			arrangedSubviews:
				[	passwordErrorCells[0],
					passwordErrorCells[1],
					passwordErrorCells[2] ]
		)
		stackView.axis = .horizontal
		stackView.spacing = 8
		return stackView
	}()
	
	private lazy var confirmPasswordTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "비밀번호를 입력해주세요",
			textFieldSubTitle: "비밀번호 확인",
			accessoryType: .image(image: CMCAsset._24x24hide.image),
			keyboardType: .default
		)
		textField.accessoryButton.setImage(CMCAsset._24x24show.image, for: .selected)
		return textField
	}()
	
	
	private lazy var passwordCheckErrorCell: CMCErrorMessage = {
		let errorCell = CMCErrorMessage(title: "비밀번호 일치", type: .disabled)
		return errorCell
	}()
	
	
	private lazy var reSettingPasswordButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.disabled),
			title: "비밀번호 변경하기"
		)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	
	// MARK: - Properties
	private var viewModel: ResettingPasswordViewModel
	private var parentViewModel: FindPasswordViewModel
	
	
	// MARK: - Initializers
	init(
		viewModel: ResettingPasswordViewModel,
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
		self.addSubview(scrollView)
		scrollView.addSubview(mainContentView)
		
		mainContentView.addSubview(titleLabel)
		mainContentView.addSubview(passwordTextField)
		mainContentView.addSubview(passwordErrorStackView)
		mainContentView.addSubview(confirmPasswordTextField)
		mainContentView.addSubview(passwordCheckErrorCell)
		self.addSubview(reSettingPasswordButton)
	}
	
	override func setConstraint() {
		
		scrollView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.bottom.equalTo(reSettingPasswordButton.snp.top)
		}
		
		mainContentView.snp.makeConstraints { make in
			make.edges.equalTo(scrollView.contentLayoutGuide)
			make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
		}
		
		titleLabel.snp.makeConstraints{ titleLabel in
			titleLabel.top.equalToSuperview().offset(30)
			titleLabel.leading.equalToSuperview().offset(24)
		}
		
		passwordTextField.snp.makeConstraints{ make in
			make.top.equalTo(titleLabel.snp.bottom).offset(24)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		passwordErrorStackView.snp.makeConstraints{ make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(9)
			make.leading.equalTo(passwordTextField).offset(5)
		}
		
		confirmPasswordTextField.snp.makeConstraints{ make in
			make.top.equalTo(passwordErrorStackView.snp.bottom).offset(30)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		passwordCheckErrorCell.snp.makeConstraints{ make in
			make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(9)
			make.leading.equalTo(confirmPasswordTextField).offset(5)
			make.bottom.equalToSuperview().offset(-24)
		}
		
		reSettingPasswordButton.snp.makeConstraints{ reSettingPasswordButton in
			reSettingPasswordButton.leading.trailing.equalToSuperview().inset(20)
			reSettingPasswordButton.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-20)
			reSettingPasswordButton.height.equalTo(56)
		}
	}
	
	override func bind() {
		
		self.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.subscribe(onNext: { owner, gesture in
				let location = gesture.location(in: owner.scrollView)
				if !owner.isPointInsideTextField(location) {
					owner.endEditing(true)
				}
			})
			.disposed(by: disposeBag)
		
		passwordTextField.accessoryState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.passwordTextField.isSecureTextEntry = !state
			})
			.disposed(by: disposeBag)
		
		confirmPasswordTextField.accessoryState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.confirmPasswordTextField.isSecureTextEntry = !state
			})
			.disposed(by: disposeBag)
		
		let input = ResettingPasswordViewModel.Input(
			email: parentViewModel.email.asObservable(),
			password: passwordTextField.rx.text.orEmpty.asObservable(),
			rePassword: confirmPasswordTextField.rx.text.orEmpty.asObservable(),
			reSettingPasswordTapped: reSettingPasswordButton.rx.tap.asObservable()
			
		)
		
		let output = viewModel.transform(input: input)
		
		output.passwordValidations.enumerated()
			.map { idx, observable in
				observable
					.withUnretained(self)
					.subscribe(onNext: { owner, active in
						let type: CMCErrorMessage.CMCErrorMessageType = active ? .success : .disabled
						owner.passwordErrorCells[idx].rxType.accept(type)
					})
			}
			.forEach { $0.disposed(by: disposeBag) }
		
		output.passwordConfirmRegex
			.withUnretained(self)
			.subscribe(onNext: { owner, active in
				let type: CMCErrorMessage.CMCErrorMessageType = active ? .success : .disabled
				owner.passwordCheckErrorCell.rxType.accept(type)
			})
			.disposed(by: disposeBag)
		
		output.reSettingButtonActive
		.withUnretained(self)
		.subscribe(onNext: { owner, isEnable in
			isEnable == true
			? owner.reSettingPasswordButton.rxType.accept(.login(.inactive))
			: owner.reSettingPasswordButton.rxType.accept(.login(.disabled))
		})
		.disposed(by: disposeBag)
		
		output.reSettingPasswordResult
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] isSuccessed in
				guard let ss = self else { return }
				if isSuccessed {
					CMCBottomSheetManager.shared.showBottomSheet(
						title: "비밀번호가 변경되었습니다\n다시 로그인해주세요 :)",
						body: nil,
						buttonTitle: "확인"
					)
					ss.parentViewModel.coordinator?.userActionState.accept(.main)
				} else {
					CMCBottomSheetManager.shared.showBottomSheet(
						title: "비밀번호 변경에 실패하였습니다.",
						body: "다시 시도해주세요 :(",
						buttonTitle: "확인"
					)
				}
			})
			.disposed(by: disposeBag)
	}
	
}


extension ResettingPasswordView {
	fileprivate func isPointInsideTextField(_ point: CGPoint) -> Bool {
			// 모든 텍스트 필드를 순회하면서 탭된 위치가 텍스트 필드 내부인지 확인합니다.
			let textFields = [passwordTextField, confirmPasswordTextField]
			return textFields.contains(where: { $0.frame.contains(point) })
	}
}
