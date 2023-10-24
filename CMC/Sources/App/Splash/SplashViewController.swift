//
//  SplashViewController.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import SnapKit

import UIKit

class SplashViewController: BaseViewController {
	
	private lazy var splashImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = CMCAsset.splash.image
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let viewModel: SplashViewModel
	
	init(
		viewModel: SplashViewModel
	) {
		self.viewModel = viewModel
		super.init()
	}
	
	override func setAddSubView() {
		view.addSubview(splashImageView)
	}
	
	override func setConstraint() {
		splashImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	override func bind() {
		let input = SplashViewModel.Input()
		let output = viewModel.transform(input: input)
	}
}
