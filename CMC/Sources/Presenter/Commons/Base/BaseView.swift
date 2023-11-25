//
//  BaseView.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxSwift
import UIKit

public class BaseView: UIView {
	
	// MARK: - Properties
	var disposeBag = DisposeBag()
	
	// MARK: - Methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = CMCAsset.gray50.color
		setAddSubView()
		setAttribute()
		setConstraint()
		bind()
	}
	
	func setAddSubView() {}
	func setConstraint() {}
	func setAttribute() {}
	func bind() {}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) is called.")
	}
}
