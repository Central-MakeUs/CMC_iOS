//
//  SelfEnterQRCodeViewController.swift
//  CMC
//
//  Created by Siri on 12/10/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class SelfEnterQRCodeViewController: UIViewController {
	
	// MARK: - UI
	private lazy var coverView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		return view
	}()
	
	private lazy var navigationBar: CMCNavigationBar = {
		let navi = CMCNavigationBar(accessoryLabelHidden: true)
		navi.backgroundColor = .clear
		return navi
	}()
	
	private lazy var enterQRCodeView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray900.color
		view.layer.cornerRadius = 10
		view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
		return view
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "인증번호 입력하기"
		label.textColor = CMCAsset.gray500.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		return label
	}()
	
	private lazy var qrTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "인증번호를 입력해주세요",
			textFieldSubTitle: "인증번호",
			accessoryType: .none,
			keyboardType: .phonePad
		)
		return textField
	}()
	
	private lazy var QRCodeErrorCell: CMCErrorMessage = {
		let errorCell = CMCErrorMessage(title: "", type: .none)
		return errorCell
	}()
	
	private lazy var nextButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.inactive),
			title: "다음"
		)
		return button
	}()
	
	// MARK: - Properties
	var disposeBag = DisposeBag()
	private let viewModel: SelfEnterQRCodeViewModel
	
	// MARK: - Initializers
	init(
		viewModel: SelfEnterQRCodeViewModel
	) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
		setAddSubView()
		setConstraint()
		bind()
		CMCIndecatorManager.shared.hide()
	}
	// MARK: - Methods
	func setAddSubView() {
		view.addSubview(coverView)
		coverView.addSubview(navigationBar)
		coverView.addSubview(enterQRCodeView)
		enterQRCodeView.addSubview(titleLabel)
		enterQRCodeView.addSubview(qrTextField)
		enterQRCodeView.addSubview(QRCodeErrorCell)
		enterQRCodeView.addSubview(nextButton)
	}
	
	func setConstraint() {
		coverView.snp.makeConstraints { make in
			make.top.leading.trailing.bottom.equalToSuperview()
		}
		
		navigationBar.snp.makeConstraints { make in
			make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(68)
		}
		
		enterQRCodeView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(375)
			make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(50)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(30)
			make.centerX.equalToSuperview()
		}
		
		qrTextField.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(40)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		QRCodeErrorCell.snp.makeConstraints { make in
			make.top.equalTo(qrTextField.snp.bottom).offset(10)
			make.leading.equalTo(qrTextField).offset(5)
			make.height.equalTo(20)
		}
		
		nextButton.snp.makeConstraints { make in
			make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(56)
		}
	}
	
	func bind() {
		
		qrTextField.rxType
			.withUnretained(self)
			.subscribe(onNext: { owner, type in
				if type == .focus || type == .filed {
					owner.QRCodeErrorCell.reset()
				}
			})
			.disposed(by: disposeBag)
		
		nextButton.rx.tapped()
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.qrTextField.textField.endEditing(true)
			})
			.disposed(by: disposeBag)
		
		let input = SelfEnterQRCodeViewModel.Input(
			qrCode: qrTextField.rx.text.orEmpty.asObservable(),
			nextBtnTapped: nextButton.rx.tapped().asObservable(),
			backBtnTapped: navigationBar.backButton.rx.tapped().asObservable()
		)
		let output = viewModel.transform(input: input)
		
		output.qrCodeResult
			.withUnretained(self)
			.subscribe(onNext: { owner, result in
				print("여기는 한 번만 걸릴거야")
				let (isQRValid, resultMessage) = result
				let type: CMCErrorMessage.CMCErrorMessageType = isQRValid ? .none : .error
				let QRCodeType: CMCTextField.TextFieldType = isQRValid ? .disabled : .error
				let errorMessage: String = isQRValid ? "" : resultMessage
				owner.QRCodeErrorCell.rxType.accept(type)
				owner.qrTextField.rxType.accept(QRCodeType)
				owner.QRCodeErrorCell.setErrorMessage(message: errorMessage)
			})
			.disposed(by: disposeBag)
	}
	
}
