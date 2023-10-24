//
//  BaseViewController.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import UIKit

import RxSwift
import SnapKit


class BaseViewController: UIViewController {
	
	// MARK: - Properties
	var disposeBag = DisposeBag()
	
	// MARK: - Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = CMCAsset.background.color
		
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
	required init(coder: NSCoder) {
		fatalError("init(coder:) is called.")
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
}
