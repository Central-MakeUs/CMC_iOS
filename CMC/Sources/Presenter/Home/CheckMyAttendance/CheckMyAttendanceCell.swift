//
//  CheckMyAttendanceCell.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxGesture

import SnapKit

import UIKit
import DesignSystem

class CheckMyAttendanceCell: UITableViewCell {
	static let reuseIdentifier = "CheckMyAttendanceCell"
	
	// MARK: - UI
	private lazy var realContentView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var leftCoverView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var rightCoverView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var weekLabel: UILabel = {
		let label = UILabel()
		label.font = CMCFontFamily.Pretendard.bold.font(size: 20)
		label.textColor = CMCAsset.gray800.color
		label.text = "-주차"
		return label
	}()
	
	private lazy var dataStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 10
		stackView.alignment = .center
		stackView.addArrangedSubview(dateImage)
		stackView.addArrangedSubview(dateLabel)
		return stackView
	}()
	
	private lazy var dateImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._14x14attendanceDateInvalid.image
		return imageView
	}()
	
	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.font = CMCFontFamily.Pretendard.medium.font(size: 13)
		label.textColor = CMCAsset.gray800.color
		label.text = "--.--"
		return label
	}()
	
	private lazy var isOfflineLabel: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.disabled),
			title: "----"
		)
		return button
	}()
	
	private lazy var firstHourStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.alignment = .center
		stackView.addArrangedSubview(firstAttendanceImageView)
		stackView.addArrangedSubview(firstAttendanceLabel)
		return stackView
	}()
	
	private lazy var firstAttendanceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._20x20attendanceAbsent.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var firstAttendanceLabel: UILabel = {
		let label = UILabel()
		label.text = "1차"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 13)
		label.textColor = CMCAsset.gray800.color
		return label
	}()
	
	private lazy var centerSeparator: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		return view
	}()
	
	private lazy var secondHourStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.alignment = .center
		stackView.addArrangedSubview(secondAttendanceImageView)
		stackView.addArrangedSubview(secondAttendanceLabel)
		return stackView
	}()
	
	
	private lazy var secondAttendanceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._20x20attendanceAbsent.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var secondAttendanceLabel: UILabel = {
		let label = UILabel()
		label.text = "2차"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 13)
		label.textColor = CMCAsset.gray800.color
		return label
	}()
	
	private lazy var bottomSeparator: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		return view
	}()
	
	// MARK: - Properties
	private var disposeBag = DisposeBag()
	
	// MARK: - Initialize
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		setAddSubviews()
		setAddConstraints()
		self.contentView.backgroundColor = CMCAsset.background.color
		self.isUserInteractionEnabled = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Methods
	private func setAddSubviews() {
		contentView.addSubview(realContentView)
		
		realContentView.addSubview(leftCoverView)
		realContentView.addSubview(rightCoverView)
		
		leftCoverView.addSubview(weekLabel)
		leftCoverView.addSubview(dataStackView)
		leftCoverView.addSubview(isOfflineLabel)
		
		rightCoverView.addSubview(firstHourStackView)
		rightCoverView.addSubview(centerSeparator)
		rightCoverView.addSubview(secondHourStackView)
		
		contentView.addSubview(bottomSeparator)
	}
	
	private func setAddConstraints() {
		
		realContentView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(23)
			make.trailing.equalToSuperview().offset(-29)
			make.top.equalToSuperview().offset(25)
			make.bottom.equalToSuperview().offset(-25)
		}
		
		leftCoverView.snp.makeConstraints { make in
			make.top.leading.bottom.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.34)
		}
		
		weekLabel.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		dateImage.snp.makeConstraints { make in
			make.height.width.equalTo(14)
		}
		
		dataStackView.snp.makeConstraints { make in
			make.centerX.equalTo(weekLabel)
			make.top.equalTo(weekLabel.snp.bottom).offset(12)
		}
		
		isOfflineLabel.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalToSuperview().multipliedBy(0.26)
		}
		
		rightCoverView.snp.makeConstraints { make in
			make.top.bottom.trailing.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.42)
		}
		
		firstAttendanceImageView.snp.makeConstraints { make in
			make.height.width.equalTo(20)
		}
		
		firstHourStackView.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.centerY.equalToSuperview()
		}
		
		centerSeparator.snp.makeConstraints { make in
			make.centerY.equalTo(firstAttendanceImageView)
			make.height.equalTo(2)
			make.leading.equalTo(firstAttendanceImageView.snp.trailing).offset(12)
			make.trailing.equalTo(secondAttendanceImageView.snp.leading).offset(-12)
		}
		
		secondAttendanceImageView.snp.makeConstraints { make in
			make.height.width.equalTo(20)
		}
		
		secondHourStackView.snp.makeConstraints { make in
			make.trailing.equalToSuperview()
			make.centerY.equalToSuperview()
		}
		
		bottomSeparator.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalTo(1)
		}
	}
	
	func configure(with model: AttendanceDetailsModel) {
		weekLabel.text = "\(model.week)" + "주차"
		
		dateLabel.text = onlyDate(date: "\(model.date)")
		
		let title = model.isOffline ? "Offline" : "Online"
		let type = model.enable
		? CMCButton.CMCButtonType.login(.none)
		: CMCButton.CMCButtonType.login(.disabled)
		isOfflineLabel.setTitle(title: title)
		isOfflineLabel.rxType.accept(type)
		
		switch model.firstHour {
		case "ABSENT":
			firstAttendanceImageView.image = CMCAsset._20x20attendanceAbsent.image
		case "LATE":
			firstAttendanceImageView.image = CMCAsset._20x20attendanceLate.image
		default:
			firstAttendanceImageView.image = CMCAsset._20x20attendanceValid.image
		}
		
		switch model.firstHour {
		case "ABSENT":
			firstAttendanceLabel.textColor = CMCAsset.gray800.color
		case "LATE":
			firstAttendanceLabel.textColor = CMCAsset.error.color
		default:
			firstAttendanceLabel.textColor = CMCAsset.gray50.color
		}
		
		switch model.secondHour {
		case "ABSENT":
			secondAttendanceImageView.image = CMCAsset._20x20attendanceAbsent.image
		case "LATE":
			secondAttendanceImageView.image = CMCAsset._20x20attendanceLate.image
		default:
			secondAttendanceImageView.image = CMCAsset._20x20attendanceValid.image
		}
		
		switch model.secondHour {
		case "ABSENT":
			secondAttendanceLabel.textColor = CMCAsset.gray800.color
		case "LATE":
			secondAttendanceLabel.textColor = CMCAsset.error.color
		default:
			secondAttendanceLabel.textColor = CMCAsset.gray50.color
		}
		
		if model.enable {
			weekLabel.textColor = CMCAsset.gray50.color
			dateImage.image = CMCAsset._14x14attendanceDateValid.image
			dateLabel.textColor = CMCAsset.gray700.color
		} else {
			weekLabel.textColor = CMCAsset.gray800.color
			dateImage.image = CMCAsset._14x14attendanceDateInvalid.image
			dateLabel.textColor = CMCAsset.gray800.color
			isOfflineLabel.rxType.accept(.login(.disabled))
			firstAttendanceImageView.image = CMCAsset._20x20attendanceAbsent.image
			firstAttendanceLabel.textColor = CMCAsset.gray800.color
			secondAttendanceImageView.image = CMCAsset._20x20attendanceAbsent.image
			secondAttendanceLabel.textColor = CMCAsset.gray800.color
		}
		
	}
}


extension CheckMyAttendanceCell{
		func onlyDate(date: String) -> String {
			let inputFormatter = DateFormatter()
			inputFormatter.dateFormat = "yyyy-MM-dd"

			if let date = inputFormatter.date(from: date) {
					let outputFormatter = DateFormatter()
					outputFormatter.dateFormat = "MM.dd"
					
					let formattedDateString = outputFormatter.string(from: date)
					return formattedDateString
			} else {
					return date
			}
		}
}
