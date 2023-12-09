//
//  CMCButton.swift
//  CMC
//
//  Created by Siri on 2023/10/22.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//
import Foundation

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

import UIKit

public final class CMCButton: UIView{
	
	// MARK: - UI
	private lazy var buttonLabel: UILabel = {
		var label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
		return label
	}()
	
	private lazy var buttonIcon: UIImageView = {
		var imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private lazy var buttonStackView: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [buttonLabel, buttonIcon])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 4
		return stackView
	}()
	
	
	// MARK: - Properties
	typealias CMCButtonUISet = (boarderColor: UIColor, mainColor: UIColor, backgroundColor: UIColor)
	
	var disposeBag = DisposeBag()
	
	private var isRound: Bool
	private var iconTitle: String?
	private var title: String
	private var type: CMCButtonType
	
	public var rxType = BehaviorRelay<CMCButtonType>(value: .login(.inactive))
	
	// MARK: - Initializers
	
	/// 버튼의 `isRound`, `iconTitle`, `buttonType`, `title`을 설정합니다.
	/// - Parameters:
	///   - isRound : 버튼의 layer를 둥글게 할지 결정합니다.
	///   - iconTitle : 버튼의 이미지를 설정합니다. (nil이면 icon을 사용 안한다는 의미)
	///   - buttonType : 버튼의 타입을 결정함 ( ex: fill, outline, boldOutline )
	///   - title: 버튼의 타이틀을 설정합니다.
	public init(isRound: Bool, iconTitle: String? = nil, type: CMCButtonType, title: String) {
		self.isRound = isRound
		self.iconTitle = iconTitle
		self.type = type
		self.title = title
		super.init(frame: .zero)
		
		self.setAddSubView()
		self.setConstraint()
		self.setAttribute()
		
		self.bind()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(buttonStackView)
	}
	
	private func setConstraint() {
		buttonIcon.snp.makeConstraints {
			$0.width.height.equalTo(24)
		}
		
		buttonStackView.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
	private func setAttribute() {
		self.layer.cornerRadius = isRound ? self.frame.height / 2 : 8
		self.layer.borderWidth = 1
		self.buttonLabel.text = title
		if let title = self.iconTitle {
			self.buttonIcon.image = UIImage(named: title)
		} else {
			buttonIcon.isHidden = true
		}
		self.rxType.accept(type)
	}
	
	private func bind() {
		
		rxType
			.withUnretained(self)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { owner, type in
				owner.configureUISet(type: type)
			})
			.disposed(by: disposeBag)
	}
	
	private func configureUISet(type: CMCButtonType) {
		// TODO: 여기서 색깔놀이 하자
		let UISet = type.UISet
		self.layer.borderColor = UISet.boarderColor.cgColor
		self.buttonLabel.textColor = UISet.mainColor
		self.buttonIcon.tintColor = UISet.mainColor
		self.backgroundColor = UISet.backgroundColor
		self.isUserInteractionEnabled = type.isEnable
	}
	
	public func makeCustomState(type: CMCButtonType) {
		rxType.accept(type)
	}
	
	public func setTitle(title: String) {
		self.buttonLabel.text = title
	}
	
}

// MARK: - CMCButton.ButtonType
extension CMCButton{
	
	/// 버튼의 상태에 따라서
	/// `boarderColor`, `mainColor`, `backgroundColor` 를 선택한다.
	/// - Parameters:
	///   - boarderColor : 버튼의 boarderColor
	///   - mainColor : 버튼의 accessoryFillColor, textColor
	///   - backgroundColor : 버튼의 backgroundColor
	
	public enum CMCButtonType {
		case login(LoginStyle)
		
		public enum LoginStyle {
			case inactive
			case clear
			case disabled
			case none
		}
		
		var isEnable: Bool {
			switch self {
			case .login(let style):
				switch style {
				case .inactive, .clear:
					return true
				case .disabled:
					return false
				case .none:
					return false
				}
			}
			
		}
		
		var UISet: CMCButtonUISet {
			switch self {
			
			case .login(let style):
				switch style {
				case .disabled:
					return CMCButtonUISet(
						boarderColor: DesignSystemAsset.gray900.color,
						mainColor: DesignSystemAsset.gray700.color,
						backgroundColor: DesignSystemAsset.gray900.color
					)
				case .clear:
					return CMCButtonUISet(
						boarderColor: DesignSystemAsset.main1.color,
						mainColor: DesignSystemAsset.gray400.color,
						backgroundColor: .clear
					)
				case .inactive:
					return CMCButtonUISet(
						boarderColor: DesignSystemAsset.main1.color,
						mainColor: DesignSystemAsset.gray50.color,
						backgroundColor: DesignSystemAsset.main1.color
					)
				case .none:
					return CMCButtonUISet(
						boarderColor: DesignSystemAsset.gray800.color,
						mainColor: DesignSystemAsset.gray50.color,
						backgroundColor: DesignSystemAsset.gray800.color
					)
				}
			}
		}
	}
	
	
}

extension Reactive where Base: CMCButton {
	public var tap: ControlEvent<Void> {
		let source: Observable<Void> = self.base.rx.tapGesture()
			.when(.recognized)
			.map { _ in () }
		return ControlEvent(events: source)
	}
	
}
