//
//  CMCBottomSheetWithAction.swift
//  DesignSystem
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

import UIKit

public final class CMCBottomSheetWithAction: UIView{
	
	// MARK: - UI
	
	private lazy var mainTitle: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
		label.textColor = DesignSystemAsset.gray50.color
		label.numberOfLines = 0
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 10
		let attributedString = NSAttributedString(
				string: title,
				attributes: [
						.paragraphStyle: paragraphStyle,
				]
		)
		label.attributedText = attributedString
		label.textAlignment = .center
		return label
	}()
	
	private lazy var bodyLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.medium.font(size: 13)
		label.textColor = DesignSystemAsset.gray600.color
		label.text = body
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	public lazy var cancelButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.inactive),
			title: buttonTitle
		)
		return button
	}()
	
	public lazy var doActionButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .actionWithdisable,
			title: actionTitle ?? ""
		)
		return button
	}()
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	
	private var title: String
	private var body: String?
	private var buttonTitle: String
	private var actionTitle: String
	
	public var isAction = PublishRelay<Void>()
	
	// MARK: - Initializers
	
	/// 버튼의 `title`, `body`, `cancelTitle`을 설정합니다.
	/// - Parameters:
	///   - title : BottomSheet의 메인 타이틀을 결정합니다.
	///   - body : BottomSheet의 본문을 결정합니다.
	///   - buttonTitle : BottomSheet의 버튼의 타이틀을 결정합니다.
	public init(title: String, body: String?, buttonTitle: String, actionTitle: String) {
		self.title = title
		self.body = body
		self.buttonTitle = buttonTitle
		self.actionTitle = actionTitle
		super.init(frame: .zero)
		
		self.backgroundColor = DesignSystemAsset.gray900.color
		self.layer.cornerRadius = 10
		
		self.setAddSubView()
		self.setConstraint()
		
		self.bind()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(mainTitle)
		self.addSubview(bodyLabel)
		self.addSubview(cancelButton)
		self.addSubview(doActionButton)
	}
	
	private func setConstraint() {
		
		mainTitle.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(68)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.centerX.equalToSuperview()
		}
		
		bodyLabel.snp.makeConstraints { make in
			make.top.equalTo(mainTitle.snp.bottom).offset(15)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
		}
		
		doActionButton.snp.makeConstraints { make in
			make.height.equalTo(56)
			make.width.equalToSuperview().multipliedBy(0.5).offset(-36)
			make.leading.equalToSuperview().offset(24)
			make.bottom.equalToSuperview().offset(-54)
		}
		
		cancelButton.snp.makeConstraints { make in
			make.height.equalTo(56)
			make.width.equalToSuperview().multipliedBy(0.5).offset(-36)
			make.trailing.equalToSuperview().offset(-24)
			make.bottom.equalToSuperview().offset(-54)
		}
		
	}
	
	private func bind() {
		doActionButton.rx.tap
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.isAction.accept(())
			})
			.disposed(by: disposeBag)
	}
	
}
