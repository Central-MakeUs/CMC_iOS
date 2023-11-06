//
//  MainSignUpView.swift
//  CMC
//
//  Created by Siri on 10/28/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxGesture
import RxSwift

import DesignSystem
import SnapKit

import UIKit

final class MainSignUpView: BaseView {
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

	private lazy var emailTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "이메일을 입력해주세요",
			textFieldSubTitle: "이메일",
			accessoryType: .button(title: "중복확인"),
			keyboardType: .emailAddress
		)
		return textField
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
	
	private lazy var nameTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "이름을 입력해주세요",
			textFieldSubTitle: "이름",
			accessoryType: .none,
			keyboardType: .default
		)
		return textField
	}()
	
	// MARK: - Properties
	private var viewModel: MainSignUpViewModel
	private var parentViewModel: SignUpViewModel
	
	
	// MARK: - Initializers
	init(
		viewModel: MainSignUpViewModel,
		parentViewModel: SignUpViewModel
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
		
		mainContentView.addSubview(emailTextField)
		mainContentView.addSubview(passwordTextField)
		mainContentView.addSubview(passwordErrorStackView)
		mainContentView.addSubview(confirmPasswordTextField)
		mainContentView.addSubview(passwordCheckErrorCell)
		mainContentView.addSubview(nameTextField)
	}
	
	override func setConstraint() {
		
		scrollView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.bottom.equalTo(self.layoutMarginsGuide.snp.bottom).offset(-56 - 10 - 20)
		}
		
		mainContentView.snp.makeConstraints { make in
			make.edges.equalTo(scrollView.contentLayoutGuide)
			make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
			make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide.snp.height).offset(1)
		}
		
		emailTextField.snp.makeConstraints{ make in
			make.top.equalToSuperview()
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		passwordTextField.snp.makeConstraints{ make in
			make.top.equalTo(emailTextField.snp.bottom).offset(30)
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
		}
		
		nameTextField.snp.makeConstraints{ make in
			make.top.equalTo(passwordCheckErrorCell.snp.bottom).offset(30)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
	}
	
	override func bind() {
		scrollView.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.endEditing(true)
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
				owner.passwordTextField.isSecureTextEntry = !state
			})
			.disposed(by: disposeBag)

	}
	
}
