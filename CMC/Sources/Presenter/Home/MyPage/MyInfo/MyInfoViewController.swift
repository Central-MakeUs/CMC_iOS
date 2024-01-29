//
//  MyInfoViewController.swift
//  CMC
//
//  Created by Siri on 12/6/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class MyInfoViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: false
		)
		navigationBar.accessoryLabel.text = ""
		navigationBar.translatesAutoresizingMaskIntoConstraints = false
		return navigationBar
	}()
	
	private lazy var navigationLabel: UILabel = {
		let label = UILabel()
		label.text = "내정보"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = CMCAsset.gray50.color
		return label
	}()
	
	private lazy var MyInfoCells: [UIView] = {
		let views: [UIView] = [
			UIView(),
			UIView(),
			UIView()
		]
		views.forEach{ $0.backgroundColor = .clear }
		return views
	}()
	
	private lazy var titleLabels: [UILabel] = {
		var labels: [UILabel] = []
		let texts = [
			"이름",
			"닉네임",
			"이메일"
		]
		texts.enumerated().forEach { index, text in
			let label = UILabel()
			label.font = CMCFontFamily.Pretendard.bold.font(size: 14)
			label.textColor = CMCAsset.gray500.color
			label.text = text
			labels.append(label)
		}
		return labels
	}()
	
	private lazy var infoLabels : [UILabel] = {
		var labels: [UILabel] = []
		let name: String = UserDefaultManager.shared.load(for: .name)!
		let nickname: String = UserDefaultManager.shared.load(for: .nickname)!
		let email: String = UserDefaultManager.shared.load(for: .email)!
		let texts = [
			name,
			nickname,
			email
		]
		texts.enumerated().forEach { index, text in
			let label = UILabel()
			label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
			label.textColor = CMCAsset.gray50.color
			label.text = text
			labels.append(label)
		}
		return labels
	}()
	
	private lazy var separeteBars: [UIView] = {
		let views: [UIView] = [
			UIView(),
			UIView(),
			UIView()
		]
		views.forEach{ $0.backgroundColor = DesignSystemAsset.gray700.color }
		return views
	}()
	
	private lazy var currentGenerationLabel: UILabel = {
		let label = UILabel()
		label.font = CMCFontFamily.Pretendard.bold.font(size: 15)
		label.textColor = CMCAsset.gray500.color
		label.text = "현재기수"
		return label
	}()
	
	private lazy var currentGenerationInfoLabel: CMCButton = {
		var gen = "---"
		if let data: Int = UserDefaultManager.shared.load(for: .generation) {
			gen = "\(data)기"
		}
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.none),
			title: gen
		)
		return button
	}()
	
	private lazy var currentPartInfoLabel: CMCButton = {
		var part = "---"
		if let data: String = UserDefaultManager.shared.load(for: .part) {
			part = data
		}
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.none),
			title: part
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: MyInfoViewModel
	
	// MARK: - Initializers
	init(
		viewModel: MyInfoViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - Methods
	override func setAddSubView() {
		view.addSubview(navigationBar)
		navigationBar.addSubview(navigationLabel)
		MyInfoCells.forEach{ view.addSubview($0) }
		MyInfoCells.enumerated().forEach { idx, cell in
			cell.addSubview(titleLabels[idx])
			cell.addSubview(infoLabels[idx])
			cell.addSubview(separeteBars[idx])
		}
		view.addSubview(currentGenerationLabel)
		view.addSubview(currentGenerationInfoLabel)
		view.addSubview(currentPartInfoLabel)
	}
	
	override func setConstraint() {
		navigationBar.snp.makeConstraints{ navigationBar in
			navigationBar.top.equalTo(self.view.safeAreaLayoutGuide)
			navigationBar.leading.trailing.equalToSuperview()
			navigationBar.height.equalTo(68)
		}
		
		navigationLabel.snp.makeConstraints { navigationLabel in
			navigationLabel.centerX.centerY.equalToSuperview()
		}
		
		MyInfoCells[0].snp.makeConstraints{ cell in
			cell.top.equalTo(navigationBar.snp.bottom).offset(20)
			cell.leading.equalToSuperview().offset(24)
			cell.trailing.equalToSuperview().offset(-24)
			cell.height.equalTo(74)
		}
		
		MyInfoCells[1].snp.makeConstraints{ cell in
			cell.top.equalTo(MyInfoCells[0].snp.bottom).offset(20)
			cell.leading.equalToSuperview().offset(24)
			cell.trailing.equalToSuperview().offset(-24)
			cell.height.equalTo(74)
		}
		
		MyInfoCells[2].snp.makeConstraints{ cell in
			cell.top.equalTo(MyInfoCells[1].snp.bottom).offset(20)
			cell.leading.equalToSuperview().offset(24)
			cell.trailing.equalToSuperview().offset(-24)
			cell.height.equalTo(74)
		}
		
		MyInfoCells.enumerated().forEach{ idx, cell in
			cell.snp.makeConstraints{ cell in
				titleLabels[idx].snp.makeConstraints{ label in
					label.top.equalToSuperview().offset(7)
					label.leading.equalToSuperview().offset(5)
				}
				
				infoLabels[idx].snp.makeConstraints{ label in
					label.top.equalTo(titleLabels[idx].snp.bottom).offset(10)
					label.leading.equalToSuperview().offset(5)
				}
				
				separeteBars[idx].snp.makeConstraints{ bar in
					bar.leading.trailing.equalToSuperview()
					bar.bottom.equalToSuperview().offset(-4)
					bar.height.equalTo(1)
				}
			}
		}
		
		currentGenerationLabel.snp.makeConstraints{ label in
			label.top.equalTo(MyInfoCells[2].snp.bottom).offset(27)
			label.leading.equalToSuperview().offset(30)
		}
		
		currentGenerationInfoLabel.snp.makeConstraints{ label in
			label.top.equalTo(currentGenerationLabel.snp.bottom).offset(10)
			label.leading.equalToSuperview().offset(24)
			label.width.equalTo(80)
			label.height.equalTo(30)
		}
		
		currentPartInfoLabel.snp.makeConstraints{ label in
			label.top.equalTo(currentGenerationInfoLabel)
			label.leading.equalTo(currentGenerationInfoLabel.snp.trailing).offset(8)
			label.width.equalTo(80)
			label.height.equalTo(30)
		}
		
	}
	
	override func bind() {
		
		let input = MyInfoViewModel.Input(
			backBtnTapped: navigationBar.backButton.rx.tapped().asObservable()
		)
		
		let _ = viewModel.transform(input: input)
		
	}
	
}
