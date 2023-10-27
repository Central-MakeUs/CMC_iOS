//
//  CMCNavigationBar.swift
//  DesignSystem
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

import UIKit


public final class CMCNavigationBar: UIView {
	
	// MARK: - UI
	public lazy var backButton: CMCTouchArea = {
		let backButton = CMCTouchArea(
			image: DesignSystemAsset._24x24arrowLeft.image
		)
		return backButton
	}()
	
	public lazy var accessoryLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
		label.textColor = DesignSystemAsset.gray700.color
		return label
	}()
	
	// MARK: - Properties
	private var accessoryLabelHidden: Bool
	
	// MARK: - Initializers
	init(accessoryLabelHidden: Bool) {
		self.accessoryLabelHidden = accessoryLabelHidden
		
		super.init(frame: .zero)
		
		self.backgroundColor = DesignSystemAsset.background.color
		
		self.addSubviews()
		self.addConstraints()
		self.addUIConfigure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	
	private func addSubviews() {
		self.addSubview(backButton)
		self.addSubview(accessoryLabel)
	}
	
	private func addConstraints() {
		backButton.snp.makeConstraints {
			$0.leading.equalToSuperview().offset(5)
			$0.centerY.equalToSuperview()
			$0.width.height.equalTo(44)
		}
		
		accessoryLabel.snp.makeConstraints {
			$0.trailing.equalToSuperview().offset(-24)
			$0.centerY.equalToSuperview()
		}
	}
	
	private func addUIConfigure() {
		accessoryLabel.isHidden = accessoryLabelHidden
	}
}
