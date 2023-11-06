//
//  CMCErrorMessage.swift
//  DesignSystem
//
//  Created by Siri on 11/6/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

public final class CMCErrorMessage: UIView {
	
	// MARK: - UI
	private lazy var errorAccessory: UIImageView = {
		let view = UIImageView()
		return view
	}()
	
	private lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
		label.textColor = DesignSystemAsset.error.color
		return label
	}()
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [errorAccessory, errorLabel])
		stackView.axis = .horizontal
		stackView.spacing = 8
		return stackView
	}()
	
	// MARK: - Properties
	typealias CMCErrorMessageUISet = (errorMessageColor: UIColor, accessoryImage: UIImage?)
	
	var disposeBag = DisposeBag()
	private var title = BehaviorRelay<String>(value: "")
	private var resetState: (String, CMCErrorMessageType)
	
	public var rxType = BehaviorRelay<CMCErrorMessageType>(value: .none)
	
	// MARK: - Initialize
	
	/// ErrorMessage의 `title`을 설정합니다.
	/// - Parameters:
	///   - title : Error의 타이틀을 설정합니다.
	///   - type: 초기 타입을 설정합니다.
	public init(title: String, type: CMCErrorMessageType) {
		self.title.accept(title)
		self.rxType.accept(type)
		self.resetState = (title, type)
		super.init(frame: .zero)
		
		setAddSubView()
		setConstraint()
		
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Set UI
	
	private func setAddSubView() {
		addSubview(stackView)
	}
	
	private func setConstraint() {
		stackView.snp.makeConstraints {
			$0.top.bottom.equalToSuperview()
			$0.leading.trailing.equalToSuperview()
		}
		
		errorAccessory.snp.makeConstraints {
			$0.width.height.equalTo(18)
		}
	}
	
	private func bind() {
		rxType
			.asDriver(onErrorJustReturn: .none)
			.drive(onNext: { [weak self] type in
				guard let self = self else { return }
				self.configureUISet(type: type)
			})
			.disposed(by: disposeBag)
		
		title
			.asDriver(onErrorJustReturn: "")
			.drive(onNext: { [weak self] title in
				guard let self = self else { return }
				self.errorLabel.text = title
			})
			.disposed(by: disposeBag)
	}
	
	private func configureUISet(type: CMCErrorMessageType) {
		// TODO: 여기서 색깔놀이 하자
		let UISet = type.UISet
		errorLabel.textColor = UISet.errorMessageColor
		errorAccessory.image = UISet.accessoryImage
		errorAccessory.isHidden = type == .error ? true : false
	}
	
	public func setErrorMessage(message: String) {
		title.accept(message)
	}
	
	public func reset() {
		title.accept(resetState.0)
		rxType.accept(resetState.1)
	}
	
}

// MARK: - GalapagosErrorMessage.Type
extension CMCErrorMessage {
	
	/// 에러의 상태에 따라서
	/// `errorMessageColor`, `accessoryImage` 를 선택한다.
	/// - Parameters:
	///   - errorMessageColor : 에러 라벨의 색상
	///   - accessoryImage : 악세서리 이미지
	
	public enum CMCErrorMessageType {
		case error
		case success
		case disabled
		case none
		
		var UISet: CMCErrorMessageUISet {
			switch self {
			case .error:
				return (
					errorMessageColor: DesignSystemAsset.error.color,
					accessoryImage: nil
				)
			case .success:
				return (
					errorMessageColor: DesignSystemAsset.main1.color,
					accessoryImage: DesignSystemAsset._18x18check.image
				)
			case .none:
				return (
					errorMessageColor: .clear,
					accessoryImage: nil
				)
			case .disabled:
				return (
					errorMessageColor: DesignSystemAsset.gray700.color,
					accessoryImage: DesignSystemAsset._18x18checkDisabled.image
				)
			}
		}
	}
	
}
