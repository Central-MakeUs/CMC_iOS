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
	
	private lazy var backgroundImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.splash.image
		return imageView
	}()
	
	private lazy var mainTitle: UILabel = {
		let label = UILabel()
		label.font = CMCFontFamily.Pretendard.semiBold.font(size: 26)
		label.text = "메인 홈"
		label.textColor = CMCAsset.gray50.color
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
	}
	
	// MARK: - Methods
	
	override func setAddSubView() {
		self.view.addSubview(backgroundImageView)
		self.view.addSubview(mainTitle)
		
	}
	
	override func setConstraint() {
		backgroundImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		mainTitle.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		
	}
	
	override func bind() {
		
	}
}
