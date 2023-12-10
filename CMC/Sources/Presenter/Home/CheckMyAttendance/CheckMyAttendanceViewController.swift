//
//  CheckMyAttendanceViewController.swift
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

final class CheckMyAttendanceViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var navigationBar: CMCNavigationBar = {
		let navigationBar = CMCNavigationBar(
			accessoryLabelHidden: true
		)
		return navigationBar
	}()
	
	private lazy var navigationLabel: UILabel = {
		let label = UILabel()
		label.text = "출석 확인하기"
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = CMCAsset.gray50.color
		return label
	}()
	
	private lazy var allStatusView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		view.layer.cornerRadius = 18
		return view
	}()
	
	private lazy var allStatusTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "현재 출석을 확인해주세요 :)"
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 14)
		return label
	}()
	
	private lazy var allStatusSeparator: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray700.color
		return view
	}()
	
	private lazy var allStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 50
		stackView.distribution = .equalSpacing
		stackView.alignment = .center
		stackView.addArrangedSubview(attendanceStackView)
		stackView.addArrangedSubview(lateStackView)
		stackView.addArrangedSubview(absentStackView)
		return stackView
	}()
	
	private lazy var attendanceStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 12
		stackView.alignment = .center
		stackView.addArrangedSubview(attendanceTitleLabel)
		stackView.addArrangedSubview(attendanceScoreLabel)
		return stackView
	}()
	
	private lazy var attendanceTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "출석"
		label.textColor = CMCAsset.gray500.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 17)
		return label
	}()
	
	private lazy var attendanceScoreLabel: UILabel = {
		let label = UILabel()
		label.text = "-"
		label.textColor = CMCAsset.gray400.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		return label
	}()
	
	private lazy var lateStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 12
		stackView.alignment = .center
		stackView.addArrangedSubview(lateTitleLabel)
		stackView.addArrangedSubview(lateScoreLabel)
		return stackView
	}()
	
	private lazy var lateTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "지각"
		label.textColor = CMCAsset.gray500.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 17)
		return label
	}()
	
	private lazy var lateScoreLabel: UILabel = {
		let label = UILabel()
		label.text = "-"
		label.textColor = CMCAsset.gray400.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		return label
	}()
	
	private lazy var absentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 12
		stackView.alignment = .center
		stackView.addArrangedSubview(absentTitleLabel)
		stackView.addArrangedSubview(absentScoreLabel)
		return stackView
	}()
	
	private lazy var absentTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "결석"
		label.textColor = CMCAsset.gray500.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 17)
		return label
	}()
	
	private lazy var absentScoreLabel: UILabel = {
		let label = UILabel()
		label.text = "-"
		label.textColor = CMCAsset.gray400.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		return label
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.register(CheckMyAttendanceCell.self, forCellReuseIdentifier: CheckMyAttendanceCell.reuseIdentifier)
		return tableView
	}()
	
	// MARK: - Properties
	private let viewModel: CheckMyAttendanceViewModel
	
	// MARK: - Initialize
	init(
		viewModel: CheckMyAttendanceViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		super.setAddSubView()
		
		view.addSubview(navigationBar)
		view.addSubview(navigationLabel)
		
		view.addSubview(allStatusView)
		allStatusView.addSubview(allStatusTitleLabel)
		allStatusView.addSubview(allStatusSeparator)
		allStatusView.addSubview(allStackView)
	}
	
	override func setConstraint() {
		super.setConstraint()
		
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(68)
		}
		
		navigationLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.centerY.equalTo(navigationBar.snp.centerY)
		}
		
		allStatusView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(20)
			make.leading.equalToSuperview().inset(25)
			make.trailing.equalToSuperview().inset(-19)
			make.height.equalTo(166)
		}
		
		allStatusTitleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(28)
			make.leading.equalToSuperview().offset(28)
		}
		
		allStatusSeparator.snp.makeConstraints { make in
			make.top.equalTo(allStatusTitleLabel.snp.bottom).offset(20)
			make.leading.trailing.equalToSuperview().inset(28)
			make.height.equalTo(1)
		}
		
		allStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-24)
		}
			
		tableView.snp.makeConstraints { make in
			make.top.equalTo(allStatusView.snp.bottom).offset(12)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
	}
	
	override func bind() {
		super.bind()
		
		tableView.rx.setDelegate(self)
			.disposed(by: disposeBag)
		
		let input = CheckMyAttendanceViewModel.Input(
			backBtnTapped: navigationBar.backButton.rx.tapped().asObservable()
		)
		let output = viewModel.transform(input: input)
		
		//MARK: - 우선 첫번째로, 이벤트 통짜 데이터를 다뤄봅시다
		output.attendanceDetails
			.do(onSubscribe: {
				CMCIndecatorManager.shared.show()
			}, onDispose: {
				CMCIndecatorManager.shared.hide()
			})
			.bind(to: tableView.rx.items) { tableView, row, model in
				let cell = tableView.dequeueReusableCell(withIdentifier: CheckMyAttendanceCell.reuseIdentifier) as! CheckMyAttendanceCell
				cell.model = model
				return cell
			}
			.disposed(by: disposeBag)
		
		output.attendanceAllStatus
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, data in
				owner.attendanceScoreLabel.text = "\(data.attendanceCount)"
				owner.lateScoreLabel.text = "\(data.lateCount)"
				owner.absentScoreLabel.text = "\(data.absentCount)"
			})
			.disposed(by: disposeBag)
	}
	
}


extension CheckMyAttendanceViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
}

