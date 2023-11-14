//
//  CompletedSignUpView.swift
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

final class CompletedSignUpView: BaseView {
	
	// MARK: - UI
	private lazy var nicknameTextField: CMCTextField = {
		let textField = CMCTextField(
			placeHolder: "닉네임을 입력해주세요",
			textFieldSubTitle: "닉네임",
			accessoryType: .none,
			keyboardType: .emailAddress
		)
		return textField
	}()
	
	private lazy var generationDropDownView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var generationTitleLabel: UILabel = {
		let label = UILabel()
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 14)
		label.text = "기수를 선택해주세요"
		return label
	}()
	
	private lazy var generationDropDownButton: CMCTouchArea = {
		let touchArea = CMCTouchArea(image: CMCAsset._24x24dropDown.image)
		return touchArea
	}()
	
	private lazy var generationUnderLine: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray100.color
		return view
	}()
	
	private lazy var positionDropDownView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var positionTitleLabel: UILabel = {
		let label = UILabel()
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 14)
		label.text = "포지션을 선택해주세요"
		return label
	}()
	
	private lazy var positionDropDownButton: CMCTouchArea = {
		let touchArea = CMCTouchArea(image: CMCAsset._24x24dropDown.image)
		return touchArea
	}()
	
	private lazy var positionUnderLine: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray100.color
		return view
	}()
	
	// MARK: - Properties
	private var viewModel: CompletedSignUpViewModel
	private var parentViewModel: SignUpViewModel
	
	private var generationRelay = BehaviorRelay<String>(value: "기수를 선택해주세요")
	private var positionRelay = BehaviorRelay<Part>(value: .none)
	
	// MARK: - Initializers
	init(
		viewModel: CompletedSignUpViewModel,
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
		self.addSubview(nicknameTextField)
		
		self.addSubview(generationDropDownView)
		self.addSubview(positionDropDownView)
		
		generationDropDownView.addSubview(generationTitleLabel)
		generationDropDownView.addSubview(generationDropDownButton)
		generationDropDownView.addSubview(generationUnderLine)
		
		positionDropDownView.addSubview(positionTitleLabel)
		positionDropDownView.addSubview(positionDropDownButton)
		positionDropDownView.addSubview(positionUnderLine)
	}
	
	override func setConstraint() {
		
		nicknameTextField.snp.makeConstraints{ make in
			make.top.equalToSuperview().offset(24)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		generationDropDownView.snp.makeConstraints { make in
			make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		generationDropDownButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(22)
			make.trailing.equalToSuperview()
			make.width.equalTo(48)
			make.height.equalTo(48)
		}
		
		generationTitleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(generationDropDownButton)
			make.leading.equalToSuperview().offset(5)
		}
		
		generationUnderLine.snp.makeConstraints { make in
			make.height.equalTo(2)
			make.bottom.equalToSuperview().offset(-4)
			make.leading.trailing.equalToSuperview()
		}
		
		positionDropDownView.snp.makeConstraints { make in
			make.top.equalTo(generationDropDownView.snp.bottom).offset(30)
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview().offset(-24)
			make.height.equalTo(74)
		}
		
		positionDropDownButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(22)
			make.trailing.equalToSuperview()
			make.width.equalTo(48)
			make.height.equalTo(48)
		}
		
		positionTitleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(positionDropDownButton)
			make.leading.equalToSuperview().offset(5)
		}
		
		positionUnderLine.snp.makeConstraints { make in
			make.height.equalTo(2)
			make.bottom.equalToSuperview().offset(-4)
			make.leading.trailing.equalToSuperview()
		}
	}
	
	override func bind() {
		
		self.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.endEditing(true)
			})
			.disposed(by: disposeBag)
		
		generationDropDownButton.rx.tapped()
			.flatMapLatest { _ -> Observable<String> in
				let dropDownManager = CMCBottomDropDownSheetManager.shared
				return dropDownManager.bottomDropDownSheetResponse(
					title: "기수를 선택해주세요",
					dataSource: [
						"14기",
						"13기",
						"12기",
						"11기"
					],
					buttonTitle: "닫기"
				)
			}
			.bind(to: generationRelay)
			.disposed(by: disposeBag)
		
		positionDropDownButton.rx.tapped()
			.flatMapLatest { _ -> Observable<String> in
				let dropDownManager = CMCBottomDropDownSheetManager.shared
				return dropDownManager.bottomDropDownSheetResponse(
					title: "기수를 선택해주세요",
					dataSource: [
						Part.PLANNER.rawValue,
						Part.DESIGNER.rawValue,
						Part.WEB.rawValue,
						Part.IOS.rawValue,
						Part.AOS.rawValue,
						Part.BACK_END.rawValue
					],
					buttonTitle: "닫기"
				)
			}
			.map { Part(rawValue: $0) ?? .none }
			.bind(to: positionRelay)
			.disposed(by: disposeBag)
		
		generationRelay
			.bind(to: generationTitleLabel.rx.text)
			.disposed(by: disposeBag)
		
		positionRelay
			.map { $0.rawValue }
			.bind(to: positionTitleLabel.rx.text)
			.disposed(by: disposeBag)
		
		Observable.combineLatest(
			nicknameTextField.rx.text.orEmpty,
			generationRelay,
			positionRelay
		)
		.withUnretained(self)
		.subscribe(onNext: { owner, body in
			let (nickname, generation, position) = body
			let gen = generation.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

			guard let genNum = Int(gen) else { return }
			owner.parentViewModel.nicknameRelay.accept(nickname)
			owner.parentViewModel.generationRelay.accept(genNum)
			owner.parentViewModel.positionRelay.accept(position.revertPart())
		})
		.disposed(by: disposeBag)
		
		let input = CompletedSignUpViewModel.Input(
				nickname: nicknameTextField.rx.text.orEmpty.asObservable(),
				generation: generationRelay.asObservable(),
				position: positionRelay.asObservable()
		)
		
		let output = viewModel.transform(input: input)
		output.nextAvailable
			.withUnretained(self)
			.subscribe(onNext: { owner, moveNext in
				owner.parentViewModel.readyForNextButton.accept(moveNext)
			})
			.disposed(by: disposeBag)
		
	}
	
}
