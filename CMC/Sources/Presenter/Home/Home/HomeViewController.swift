//
//  HomeViewController.swift
//  CMC
//
//  Created by Siri on 11/26/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import SafariServices
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
	
	private lazy var settingButton: CMCTouchArea = {
		let imageView = CMCTouchArea(
			image: CMCAsset._48x48setting.image
		)
		imageView.contentMode = .scaleAspectFit
		return imageView
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
		guard let nickname: String = UserDefaultManager.shared.load(for: .nickname) else { return label}
		guard let gen: Int = UserDefaultManager.shared.load(for: .generation) else { return label}
		guard let part: String = UserDefaultManager.shared.load(for: .part) else { return label}
		let text = "\(nickname)는\nCMC \(gen)기 \(part)로\n참여중이에요"
		let attributedString = NSMutableAttributedString(string: text)
		let whiteAttributes: [NSAttributedString.Key: Any] =
		[.foregroundColor: CMCAsset.gray50.color]
		let mainAttributes: [NSAttributedString.Key: Any] =
		[.foregroundColor: CMCAsset.main1.color]
		let pragraphStyle = NSMutableParagraphStyle()
		pragraphStyle.lineHeightMultiple = 1.26
		let lineHeight: [NSAttributedString.Key: Any] = [.paragraphStyle: pragraphStyle]
		let partRange = (text as NSString).range(of: part)
		attributedString.addAttributes(whiteAttributes, range: NSRange(location: 0, length: text.count))
		attributedString.addAttributes(mainAttributes, range: partRange)
		attributedString.addAttributes(lineHeight, range: NSRange(location: 0, length: text.count))
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.attributedText = attributedString
		label.font = CMCFontFamily.Pretendard.bold.font(size: 24)
		return label
	}()
	
	private lazy var bannerView: CMCBannerScrollView = {
		let view = CMCBannerScrollView(
			banners: notifications
		)
		view.layer.masksToBounds = true
		view.layer.cornerRadius = 10
		return view
	}()
	
//	private lazy var emptyBanner: CMCBannerView = {
//		let bannerView = CMCBannerView(
//			logoImage: CMCAsset._24x24pushPin.image,
//			title: "--",
//			subTitle: "등록된 배너가 없습니다.",
//			bannerUrl: ""
//		)
//		return bannerView
//	}()
//
//	private lazy var banner_two: CMCBannerView = {
//		let bannerView = CMCBannerView(
//			logoImage: CMCAsset._24x24pushPin.image,
//			title: "두번째",
//			subTitle: "맘대로 넣쟈",
//			bannerUrl: "https://www.naver.com"
//		)
//		return bannerView
//	}()
//	
//	private lazy var banner_three: CMCBannerView = {
//		let bannerView = CMCBannerView(
//			logoImage: CMCAsset._24x24pushPin.image,
//			title: "세번째",
//			subTitle: "여기까지만하자",
//			bannerUrl: "https://www.naver.com"
//		)
//		return bannerView
//	}()
	
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
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = CMCFontFamily.Pretendard.medium.font(size: 15)
		return label
	}()
	
	// MARK: - Properties
	private let viewModel: HomeViewModel
	var notifications: [CMCBannerView] = [
		CMCBannerView(
			logoImage: CMCAsset._24x24pushPin.image,
			title: "--",
			subTitle: "등록된 배너가 없습니다.",
			bannerUrl: ""
		)
	]
	
	// MARK: - Initializers
	init(
		viewModel: HomeViewModel
	) {
		self.viewModel = viewModel
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
		
		self.view.addSubview(contentView)
		
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
		
		contentView.snp.makeConstraints {
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.bottom.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(24)
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
		
		bannerView.getBannerUrl
			.withUnretained(self)
			.subscribe(onNext: { owner, url in
				print("\(url)")
				guard let url = URL(string: "https://" + url) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
		allNoticeView.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				let allNoticeURL = "https://makeus-challenge.notion.site/2591216dc54f4928a0ebfce2d6ec4cfe?pvs=4"
				guard let url = URL(string: allNoticeURL) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
		toContactView.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				let toConactURL = "https://pf.kakao.com/_xcwDJT/chat"
				guard let url = URL(string: toConactURL) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
		officialHomePageView.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, _ in
				let officialHomePageURL = "https://cmc.makeus.in"
				guard let url = URL(string: officialHomePageURL) else { return }
				let sfVC = SFSafariViewController(url: url)
				sfVC.modalPresentationStyle = .overFullScreen
				owner.present(sfVC, animated: true)
			})
			.disposed(by: disposeBag)
		
		let input = HomeViewModel.Input(
			settingButtonTapped: settingButton.rx.tapped().asObservable()
		)
		let output = viewModel.transform(input: input)
		
		output.notificationsForBanner
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { owner, notifications in
				owner.notifications.removeAll()
				notifications.forEach { noti in
					let bannerView = CMCBannerView(
						logoImage: CMCAsset._24x24pushPin.image,
						title: "\(noti.week)주차",
						subTitle:	noti.title,
						bannerUrl: noti.notionUrl
					)
					owner.notifications.append(bannerView)
				}
				owner.bannerView.updateBanners(owner.notifications)
			})
			.disposed(by: disposeBag)
		
		
	}
}
