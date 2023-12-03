//
//  HomeViewController.swift
//  CMC
//
//  Created by Siri on 11/26/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import DesignSystem
import SnapKit

import UIKit

class HomeViewController: BaseViewController {
	
	// MARK: - UI
	private lazy var appBar: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var mainLogoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.splashLogo.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var settingButton: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._48x48setting.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.backgroundColor = .clear
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	private lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var infoView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var mainInfoLabel: UILabel = {
		let label = UILabel()
		let text = "{--}는\nCMC {--}기 {---}로\n참여중이에요"
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		var paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineHeightMultiple = 1.26
		label.attributedText = NSMutableAttributedString(
			string: text,
			attributes: [
				NSAttributedString.Key.paragraphStyle: paragraphStyle
			]
		)
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 24)
		return label
	}()
	
	private lazy var bannerView: CMCBannerScrollView = {
		let view = CMCBannerScrollView(
			banners: [
				banner_one,
				banner_two,
				banner_three
			]
		)
		return view
	}()
	
	private lazy var banner_one: UIView = {
		let view = UIView()
		view.backgroundColor = .yellow
		return view
	}()
	private lazy var banner_two: UIView = {
		let view = UIView()
		view.backgroundColor = .green
		return view
	}()
	
	private lazy var banner_three: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		return view
	}()
	
	private lazy var attendanceView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var attendanceLabel: UILabel = {
		let label = UILabel()
		label.text = "출석하기 QR"
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		return label
	}()
	
	private lazy var attendanceSubLabel: UILabel = {
		let label = UILabel()
		label.text = "세션이 시작될 때\n사용해주세요!"
		label.numberOfLines = 0
		label.textColor = CMCAsset.gray700.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 11)
		return label
	}()
	
	private lazy var attendanceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._48x48qrLogo.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var checkAttendanceView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var checkAttendanceLabel: UILabel = {
		let label = UILabel()
		label.text = "내 출석 확인"
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		return label
	}()
	
	private lazy var checkAttendanceSubLabel: UILabel = {
		let label = UILabel()
		label.text = "지난 출석을 확인할 수 있어요"
		label.textColor = CMCAsset.gray700.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 11)
		return label
	}()
	
	private lazy var checkAttendanceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._20x20attendance.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var allNoticeView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var allNoticeLabel: UILabel = {
		let label = UILabel()
		label.text = "전체 공지"
		label.textColor = CMCAsset.gray50.color
		label.font = CMCFontFamily.Pretendard.bold.font(size: 18)
		return label
	}()
	
	private lazy var allNoticeSubLabel: UILabel = {
		let label = UILabel()
		label.text = "모든 공지를 확인할 수 있어요"
		label.textColor = CMCAsset.gray700.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 11)
		return label
	}()
	
	private lazy var allNoticeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._20x20megaPhone.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var toContactView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var toContactStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 6
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.addArrangedSubview(toContactImageView)
		stackView.addArrangedSubview(toContactLabel)
		return stackView
	}()
	
	private lazy var toContactLabel: UILabel = {
		let label = UILabel()
		label.text = "문의 하기"
		label.textColor = CMCAsset.gray700.color
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		return label
	}()
	
	private lazy var toContactImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset._18x18toContact.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var officialHomePageView: UIView = {
		let view = UIView()
		view.backgroundColor = CMCAsset.gray800.color
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var officialHomePageLabel: UILabel = {
		let label = UILabel()
		label.text = "CMC\n공식 홈페이지"
		label.textColor = CMCAsset.gray700.color
		label.numberOfLines = 0
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		return label
	}()
	
	// MARK: - Properties
	
	
	// MARK: - Initializers
	override init(
		
	) {
		super.init()
	}
	
	// MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setAddSubView()
		setConstraint()
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		
		self.view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(appBar)
		appBar.addSubview(mainLogoImageView)
		appBar.addSubview(settingButton)
		
		contentView.addSubview(infoView)
		infoView.addSubview(mainInfoLabel)
		
		contentView.addSubview(bannerView)
		
		contentView.addSubview(attendanceView)
		attendanceView.addSubview(attendanceLabel)
		attendanceView.addSubview(attendanceSubLabel)
		attendanceView.addSubview(attendanceImageView)
		
		contentView.addSubview(checkAttendanceView)
		checkAttendanceView.addSubview(checkAttendanceLabel)
		checkAttendanceView.addSubview(checkAttendanceSubLabel)
		checkAttendanceView.addSubview(checkAttendanceImageView)
		
		contentView.addSubview(allNoticeView)
		allNoticeView.addSubview(allNoticeLabel)
		allNoticeView.addSubview(allNoticeSubLabel)
		allNoticeView.addSubview(allNoticeImageView)
		
		contentView.addSubview(toContactView)
		toContactView.addSubview(toContactStackView)
		
		contentView.addSubview(officialHomePageView)
		officialHomePageView.addSubview(officialHomePageLabel)
		
	}
	
	override func setConstraint() {
		
		scrollView.snp.makeConstraints {
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.bottom.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(24)
		}
		
		contentView.snp.makeConstraints {
			$0.edges.equalToSuperview()
			$0.width.equalToSuperview()
			$0.height.equalToSuperview().priority(.low)
		}
		
		appBar.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview()
			$0.height.equalTo(68)
		}
		
		mainLogoImageView.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview()
			$0.width.height.equalTo(48)
		}
		
		settingButton.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.width.height.equalTo(48)
		}
		
		infoView.snp.makeConstraints {
			$0.top.equalTo(appBar.snp.bottom).offset(24)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalTo(116)
		}
		
		mainInfoLabel.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		bannerView.snp.makeConstraints {
			$0.top.equalTo(infoView.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview()
			$0.height.equalToSuperview().multipliedBy(0.185)
		}
		
		attendanceView.snp.makeConstraints {
			$0.top.equalTo(bannerView.snp.bottom).offset(18)
			$0.width.equalToSuperview().multipliedBy(0.5).offset(-8)
			$0.leading.equalToSuperview()
			$0.height.equalToSuperview().multipliedBy(0.25)
		}
		
		attendanceLabel.snp.makeConstraints {
			$0.top.leading.equalToSuperview().offset(12)
		}
		
		attendanceSubLabel.snp.makeConstraints {
			$0.top.equalTo(attendanceLabel.snp.bottom).offset(4)
			$0.leading.equalTo(attendanceLabel)
		}
		
		attendanceImageView.snp.makeConstraints {
			$0.trailing.bottom.equalToSuperview().inset(16)
			$0.width.height.equalTo(48)
		}
		
		checkAttendanceView.snp.makeConstraints {
			$0.top.equalTo(attendanceView)
			$0.width.equalToSuperview().multipliedBy(0.5).offset(-8)
			$0.trailing.equalToSuperview()
			$0.height.equalTo(attendanceView).multipliedBy(0.5).offset(-4)
		}
		
		checkAttendanceImageView.snp.makeConstraints {
			$0.leading.equalToSuperview().offset(14)
			$0.top.equalToSuperview().offset(12)
			$0.width.height.equalTo(20)
		}
		
		checkAttendanceLabel.snp.makeConstraints {
			$0.top.equalTo(checkAttendanceImageView.snp.bottom).offset(6)
			$0.leading.equalTo(checkAttendanceImageView)
		}
		
		checkAttendanceSubLabel.snp.makeConstraints {
			$0.top.equalTo(checkAttendanceLabel.snp.bottom).offset(2)
			$0.leading.equalTo(checkAttendanceImageView)
		}
		
		allNoticeView.snp.makeConstraints {
			$0.bottom.equalTo(attendanceView)
			$0.width.equalToSuperview().multipliedBy(0.5).offset(-8)
			$0.trailing.equalToSuperview()
			$0.height.equalTo(attendanceView).multipliedBy(0.5).offset(-4)
		}
		
		allNoticeImageView.snp.makeConstraints {
			$0.leading.equalToSuperview().offset(14)
			$0.top.equalToSuperview().offset(12)
			$0.width.height.equalTo(20)
		}
		
		allNoticeLabel.snp.makeConstraints {
			$0.top.equalTo(allNoticeImageView.snp.bottom).offset(6)
			$0.leading.equalTo(allNoticeImageView)
		}
		
		allNoticeSubLabel.snp.makeConstraints {
			$0.top.equalTo(allNoticeLabel.snp.bottom).offset(2)
			$0.leading.equalTo(allNoticeImageView)
		}
		
		toContactView.snp.makeConstraints {
			$0.top.equalTo(attendanceView.snp.bottom).offset(18)
			$0.leading.trailing.equalTo(attendanceView)
			$0.height.equalToSuperview().multipliedBy(0.095)
		}
		
		toContactImageView.snp.makeConstraints {
			$0.width.height.equalTo(18)
		}
		
		toContactStackView.snp.makeConstraints {
			$0.centerX.centerY.equalToSuperview()
		}
		
		officialHomePageView.snp.makeConstraints {
			$0.top.equalTo(attendanceView.snp.bottom).offset(18)
			$0.leading.trailing.equalTo(allNoticeView)
			$0.height.equalToSuperview().multipliedBy(0.095)
		}
		
		officialHomePageLabel.snp.makeConstraints {
			$0.centerY.centerX.equalToSuperview()
		}
		
	}
	
	override func bind() {
		
	}
}
