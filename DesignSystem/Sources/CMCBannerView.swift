//
//  CMCBannerView.swift
//  DesignSystem
//
//  Created by Siri on 12/3/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import UIKit
import SafariServices
import Foundation

import RxSwift
import RxCocoa
import RxGesture

import SnapKit

public final class CMCBannerView: UIView {
	
	// MARK: - UI
	private lazy var logoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = DesignSystemAsset._24x24pushPin.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = DesignSystemAsset.gray50.color
		label.text = title
		return label
	}()
	
	private lazy var subTitleLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = DesignSystemAsset.main1.color
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
		let text = subTitle + " 확인해주세요!"
		let attributedString = NSMutableAttributedString(string: text)
		let whiteAttribute: [NSAttributedString.Key: Any] =
		[.foregroundColor: DesignSystemAsset.gray50.color]
		let mainAttribute: [NSAttributedString.Key: Any] =
		[.foregroundColor: DesignSystemAsset.main1.color]
		let noticeRange = (subTitle as NSString).range(of: subTitle)
		attributedString.addAttributes(whiteAttribute, range: NSRange(location: 0, length: text.count))
		attributedString.addAttributes(mainAttribute, range: noticeRange)
		label.attributedText = attributedString
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 17)
		return label
	}()
	
	private lazy var toNotionButton: CMCTouchArea = {
		let button = CMCTouchArea(
			image: DesignSystemAsset._24x24arrowRight.image
		)
		return button
	}()
	
	// MARK: - Properties
	private let logoImage: UIImage?
	private let title: String
	private let subTitle: String
	private let bannerUrl: String
	
	private var disposeBag = DisposeBag()

	// MARK: - Initializers
	
	public init(
		logoImage: UIImage?,
		title: String,
		subTitle: String,
		bannerUrl: String
	) {
		self.logoImage = logoImage
		self.title = title
		self.subTitle = subTitle
		self.bannerUrl = bannerUrl
		super.init(frame: .zero)
		self.backgroundColor = DesignSystemAsset.gray800.color
		setSubviews()
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Functions
	
	private func setSubviews() {
		self.addSubview(logoImageView)
		self.addSubview(titleLabel)
		self.addSubview(subTitleLabel)
		self.addSubview(toNotionButton)
	}
	
	private func setConstraints() {
		
		logoImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(24)
			make.leading.equalToSuperview().offset(14)
			make.width.height.equalTo(24)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(logoImageView)
			make.leading.equalTo(logoImageView.snp.trailing).offset(8)
		}
		
		toNotionButton.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.trailing.equalToSuperview().offset(-4)
			make.width.height.equalTo(48)
		}
		
		subTitleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(toNotionButton)
			make.leading.equalTo(logoImageView)
            make.trailing.equalTo(toNotionButton.snp.leading).offset(16)
		}
	}
	
	public func getUrl() -> String {
		return self.bannerUrl
	}
	
}


extension CMCBannerView {
		func clone() -> CMCBannerView {
				let clonedBanner = CMCBannerView(
					logoImage: logoImage,
					title: title,
					subTitle: subTitle,
					bannerUrl: bannerUrl
				)
				return clonedBanner
		}
}
