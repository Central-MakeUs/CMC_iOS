//
//  AttendanceCompletedViewController.swift
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

class AttendanceCompletedViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var attendanceCompletedLabel: UILabel = {
		let label = UILabel()
		var nickname = "--"
		if let data: String = UserDefaultManager.shared.load(for: .nickname) {
			nickname = data
		}
		label.text = nickname + "님의\n출석이 완료되었어요!"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 26)
		label.textColor = CMCAsset.gray50.color
		label.numberOfLines = 2
		return label
	}()
	
	private lazy var attendanceCompletedSubLabel: UILabel = {
		let label = UILabel()
		label.text = "잠시 후 시작되는 세션에 집중해주세요 :)"
		label.font = CMCFontFamily.Pretendard.medium.font(size: 14)
		label.textColor = CMCAsset.gray700.color
		return label
	}()
	
	private lazy var attendanceCompletedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.signUpCompleted.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var completedButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			type: .login(.inactive),
			title: "완료"
		)
		return button
	}()
	
	// MARK: - Properties
	private let viewModel: AttendanceCompletedViewModel
	
	// MARK: - Initializers
	init(
		viewModel: AttendanceCompletedViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	
	override func setAddSubView() {
		self.view.addSubview(self.attendanceCompletedLabel)
		self.view.addSubview(self.attendanceCompletedSubLabel)
		self.view.addSubview(self.attendanceCompletedImageView)
		self.view.addSubview(self.completedButton)
	}
	
	override func setConstraint() {
		self.attendanceCompletedLabel.snp.makeConstraints { make in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
			make.leading.equalToSuperview().offset(24)
		}
		
		self.attendanceCompletedSubLabel.snp.makeConstraints { make in
			make.top.equalTo(self.attendanceCompletedLabel.snp.bottom).offset(15)
			make.leading.equalTo(self.attendanceCompletedLabel.snp.leading)
		}
		
		self.attendanceCompletedImageView.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.width.equalTo(435)
			make.height.equalTo(435)
		}
		
		self.completedButton.snp.makeConstraints { make in
			make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(56)
		}
	}
	
	override func bind() {
		let input = AttendanceCompletedViewModel.Input(
			completedBtnTapped: completedButton.rx.tap.asObservable()
		)
		let _ = viewModel.transform(input: input)
	}
	
}
