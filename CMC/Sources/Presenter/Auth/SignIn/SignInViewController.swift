//
//  SignInViewController.swift
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

final class SignInViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: true
		)
		return navigationBar
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "로그인"
		label.numberOfLines = 2
		label.font = CMCFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = DesignSystemAsset.gray50.color
		return label
	}()
	
	private lazy var emailTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "이메일을 입력해주세요",
			textFieldSubTitle: "이메일",
			accessoryType: .none,
			keyboardType: .default
		)
		return textField
	}()
	
	private lazy var passwordTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "비밀번호를 입력해주세요",
			textFieldSubTitle: "비밀번호",
			accessoryType: .image(image: CMCAsset._24x24show.image),
			keyboardType: .emailAddress
		)
		textField.accessoryButton.setImage(CMCAsset._24x24hide.image, for: .selected)
		return textField
	}()
	
	private lazy var forgetEmailLabel: UILabel = {
		let label = UILabel()
		let text = "아이디를 잊으셨나요?"
		let attributedString = NSMutableAttributedString(string: text)
		
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 4)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = CMCFontFamily.Pretendard.bold.font(size: 13)
		label.textColor = CMCAsset.gray500.color
		return label
	}()
	
	private lazy var forgetPasswordLabel: UILabel = {
		let label = UILabel()
		let text = "비밀번호를 잊으셨나요?"
		let attributedString = NSMutableAttributedString(string: text)
		
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 4)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = CMCFontFamily.Pretendard.bold.font(size: 13)
		label.textColor = CMCAsset.gray500.color
		return label
	}()
	
	private lazy var forgetStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [forgetEmailLabel, forgetPasswordLabel])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 26
		return stackView
	}()
	
	
	private lazy var askSignUpLabel: UILabel = {
		let label = UILabel()
		label.text = "계정이 없으신가요?"
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		label.textColor = CMCAsset.gray700.color
		return label
	}()
	
	private lazy var goSignUpLabel: UILabel = {
		let label = UILabel()
		let text = "회원가입 하기"
		let attributedString = NSMutableAttributedString(string: text)
		
		let underLineAttributes: [NSAttributedString.Key: Any] = [
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.baselineOffset : NSNumber(value: 4)
		]
		attributedString.addAttributes(underLineAttributes, range: NSRange(location: 0, length: text.count))
		label.attributedText = attributedString
		label.font = CMCFontFamily.Pretendard.bold.font(size: 13)
		label.textColor = CMCAsset.gray500.color
		return label
	}()
	
	private lazy var goSignUpStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [askSignUpLabel, goSignUpLabel])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 7
		return stackView
	}()
	
	private lazy var signInButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.disabled),
			title: "로그인")
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: SignInViewModel
	
	// MARK: - Initializers
	init(
		viewModel: SignInViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	override func setAddSubView() {
		view.addSubview(navigationBar)
		view.addSubview(titleLabel)
		view.addSubview(emailTextField)
		view.addSubview(passwordTextField)
		view.addSubview(forgetStackView)
		view.addSubview(goSignUpStackView)
		view.addSubview(signInButton)
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(68)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(20)
			make.leading.equalToSuperview().offset(24)
		}
		
		emailTextField.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(30)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-28)
			make.height.equalTo(74)
		}
		
		passwordTextField.snp.makeConstraints { make in
			make.top.equalTo(emailTextField.snp.bottom).offset(20)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-28)
			make.height.equalTo(74)
		}
		
		forgetStackView.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(32)
			make.centerX.equalToSuperview()
		}
		
		goSignUpStackView.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30 - 56 - 20)
			make.centerX.equalToSuperview()
		}
		
		signInButton.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(56)
		}
	}
	
	override func bind() {
		
		NotificationManager.shared.keyboardHeightSubject
			.withUnretained(self)
			.subscribe(onNext: { owner, keyboardHeight in
				let realHeight = keyboardHeight > 0 ? keyboardHeight - 30 : 0
				owner.signInButton.snp.updateConstraints { make in
					make.bottom.equalTo(owner.view.safeAreaLayoutGuide.snp.bottom).offset(-20 - realHeight)
				}
				UIView.animate(withDuration: 0.3) {
					owner.view.layoutIfNeeded()
				}
			})
			.disposed(by: disposeBag)
		
		passwordTextField.accessoryState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.passwordTextField.isSecureTextEntry = state
			})
			.disposed(by: disposeBag)
		
		let input = SignInViewModel.Input(
			email: emailTextField.rx.text.orEmpty.asObservable(),
			password: passwordTextField.rx.text.orEmpty.asObservable(),
			backBtnTapped: navigationBar.backButton.rx.tapped().asObservable(),
			forgetIDBtnTapped: forgetEmailLabel.rx.tapGesture().when(.recognized).map{_ in }.asObservable(),
			forgetPasswordBtnTapped: forgetPasswordLabel.rx.tapGesture().when(.recognized).map{_ in }.asObservable(),
			goSignUpButtonTapped: goSignUpLabel.rx.tapGesture().when(.recognized).map{_ in }.asObservable(),
			goSignInButtonTapped: signInButton.rx.tap.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.signInBtnEnable
			.withUnretained(self)
			.subscribe(onNext: { owner, enable in
				enable == true
				? owner.signInButton.rxType.accept(.login(.inactive))
				: owner.signInButton.rxType.accept(.login(.disabled))
			})
			.disposed(by: disposeBag)
		
	}
	
}


// MARK: - Extension
extension SignInViewController {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}
