//
//  TermsAndConditionsView.swift
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

final class TermsAndConditionsView: BaseView {
	// MARK: - UI
	
	private lazy var buttonStackViews: [UIStackView] = {
		var stackViews: [UIStackView] = []
		buttons.enumerated().forEach { index, button in
			let stackView = UIStackView()
			stackView.axis = .horizontal
			stackView.alignment = .center
			stackView.addArrangedSubview(button)
			stackView.addArrangedSubview(buttonLabels[index])
			stackViews.append(stackView)
		}
		return stackViews
	}()
	
	private lazy var buttons: [CMCTouchArea] = {
		let selectedImage = CMCAsset._24x24abled.image
		let normalImage = CMCAsset._24x24disabled.image
		let buttons = [
			CMCTouchArea(image: normalImage),
			CMCTouchArea(image: normalImage),
			CMCTouchArea(image: normalImage),
			CMCTouchArea(image: normalImage),
			CMCTouchArea(image: normalImage)
		]
		buttons.forEach{ $0.setImage(selectedImage, for: .selected)}
		return buttons
	}()
	
	private lazy var accessoryDetailButton : [CMCTouchArea] = {
		let image = CMCAsset._16x16arrowLeft.image
		let buttons = [
			CMCTouchArea(image: image),
			CMCTouchArea(image: image),
			CMCTouchArea(image: image),
			CMCTouchArea(image: image)
		]
		return buttons
	}()
	
	private lazy var buttonLabels: [UILabel] = {
		var labels: [UILabel] = []
		let texts = [
			"전체 동의",
			"서비스 이용약관(필수)",
			"개인정보 수집/이용 (필수)",
			"위치정보 이용 동의(선택)",
			"마케팅 정보 수신 동의(선택)"
		]
		texts.enumerated().forEach { index, text in
			let label = UILabel()
			if index == 0 {
				label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
			} else {
				label.font = CMCFontFamily.Pretendard.bold.font(size: 14)
			}
			label.textColor = CMCAsset.gray50.color
			label.text = text
			labels.append(label)
		}
		return labels
	}()
	
	private lazy var separeteBar: UIView = {
		let view = UIView()
		view.backgroundColor = DesignSystemAsset.gray800.color
		return view
	}()
	
	private lazy var rowStackViews: [UIStackView] = {
		var stackViews: [UIStackView] = []
		accessoryDetailButton.enumerated().forEach { index, button in
			let stackView = UIStackView()
			stackView.addArrangedSubview(buttonStackViews[index+1])
			stackView.addArrangedSubview(button)
			stackView.axis = .horizontal
			stackViews.append(stackView)
		}
		return stackViews
	}()
	
	// MARK: - Properties
	private var viewModel: TermsAndConditionsViewModel
	private var parentViewModel: SignUpViewModel
	
	// MARK: - Initializers
	init(
		viewModel: TermsAndConditionsViewModel,
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
		self.addSubview(buttonStackViews[0])
		self.addSubview(separeteBar)
		self.addSubview(rowStackViews[0])
		self.addSubview(rowStackViews[1])
		self.addSubview(rowStackViews[2])
		self.addSubview(rowStackViews[3])
	}
	
	override func setConstraint() {
		buttons.forEach { button in
			button.snp.makeConstraints { make in
				make.width.height.equalTo(44)
			}
		}
		
		accessoryDetailButton.forEach { button in
			button.snp.makeConstraints { make in
				make.width.height.equalTo(44)
			}
		}
		
		buttonStackViews[0].snp.makeConstraints{ make in
			make.top.equalToSuperview()
			make.leading.equalToSuperview().offset(14)
		}
		
		separeteBar.snp.makeConstraints{ make in
			make.top.equalTo(buttonStackViews[0].snp.bottom).offset(10)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(1)
		}
		
		rowStackViews[0].snp.makeConstraints { make in
			make.top.equalTo(separeteBar.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(14)
			make.trailing.equalToSuperview().offset(-5)
		}
		
		rowStackViews[1].snp.makeConstraints { make in
			make.top.equalTo(rowStackViews[0].snp.bottom).offset(2)
			make.leading.trailing.equalTo(rowStackViews[0])
		}
		
		rowStackViews[2].snp.makeConstraints { make in
			make.top.equalTo(rowStackViews[1].snp.bottom).offset(2)
			make.leading.trailing.equalTo(rowStackViews[0])
		}
		
		rowStackViews[3].snp.makeConstraints { make in
			make.top.equalTo(rowStackViews[2].snp.bottom).offset(2)
			make.leading.trailing.equalTo(rowStackViews[0])
		}
		
	}
	
	override func bind() {
		
		let input = TermsAndConditionsViewModel.Input(
			allAgreeBtnTapped: buttons[0].rx.tapped().asObservable(),
			termsBtnTapped: buttons[1].rx.tapped().asObservable(),
			conditionBtnTapped: buttons[2].rx.tapped().asObservable(),
			locateBtnTapped: buttons[3].rx.tapped().asObservable(),
			eventBtnTapped: buttons[4].rx.tapped().asObservable()
		)
		
		let output = viewModel.transform(input: input)
		
		output.allAgreeBtnState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.buttons[0].makeCustomState(type: state ? .selected : .normal)
			})
			.disposed(by: disposeBag)
		
		output.termsBtnState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.buttons[1].makeCustomState(type: state ? .selected : .normal)
			})
			.disposed(by: disposeBag)
		
		output.conditionBtnState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.buttons[2].makeCustomState(type: state ? .selected : .normal)
			})
			.disposed(by: disposeBag)
		
		output.locateBtnState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.buttons[3].makeCustomState(type: state ? .selected : .normal)
			})
			.disposed(by: disposeBag)
		
		output.eventBtnState
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, state in
				owner.buttons[4].makeCustomState(type: state ? .selected : .normal)
			})
			.disposed(by: disposeBag)
		
		output.moveToNext
			.withUnretained(self)
			.bind(onNext: { owner, state in
				owner.parentViewModel.readyForNextButton.accept(state)
			})
			.disposed(by: disposeBag)
		
	}
}
