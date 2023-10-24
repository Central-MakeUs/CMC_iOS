//
//  CMCTextField.swift
//  DesignSystem
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//
import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

public final class CMCTextField: UIView{
	
	// MARK: - UI
	fileprivate lazy var textField: UITextField = {
		let textField = UITextField()
		let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: textField.frame.height))
		let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: textField.frame.height))
		textField.leftView = leftPadding
		textField.rightView = rightPadding
		textField.leftViewMode = .always
		textField.rightViewMode = .always
		textField.placeholder = placeHolder
		textField.layer.cornerRadius = 5
		textField.layer.borderWidth = 1
		textField.keyboardType = keyboardType
		textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: 15)
		textField.textColor = DesignSystemAsset.gray50.color
		return textField
	}()
	
	private lazy var textFieldTitle: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
		label.textColor = DesignSystemAsset.gray200.color
		return label
	}()
	
	public lazy var accessoryButton: CMCTouchArea = {
		let button = CMCTouchArea(image: accessoryImage)
		return button
	}()
	
	// MARK: - Properties
	typealias TextFieldColorSet = (
		borderColor: UIColor,
		textFieldBackgroundColor: UIColor,
		textFieldTextColor: UIColor,
		isUserInteractive: Bool
	)
	
	private var disposeBag = DisposeBag()
	
	private var placeHolder: String
	private var accessoryImage: UIImage?
	private var keyboardType: UIKeyboardType
	
	public var rxType = BehaviorRelay<TextFieldType>(value: .def)
	public var accessoryState = BehaviorRelay<Bool>(value: false)
	
	/// 텍스트필드의 `placeHolder`, `maxCount`를 설정합니다.
	/// - Parameters:
	///   - placeHolder : placeHolder로 들어갈 텍스트
	///   - accessoryImage: 우측 악세서리에 들어가는 버튼의 이미지 (nil 이면 없음)
	///   - keyboardType: 키보드 타입
	/// - Parameters (Optional):
	///   - keyboardType : 키보드 타입
	///   - hideMode : isSecureTextEntry를 조절하는 버튼 on / off
	/// - Parameters (Accessable):
	///   - rxType: GalapagosTextField의 타입변환 조종값
	///   - accessoryState: 우측 악세서리 버튼의 상태
	// MARK: - Initializers
	public init(
		placeHolder: String,
		accessoryImage: UIImage?,
		keyboardType: UIKeyboardType
	) {
		self.placeHolder = placeHolder
		self.accessoryImage = accessoryImage
		self.keyboardType = keyboardType
		
		super.init(frame: .zero)
		
		textField.delegate = self
		
		setAddSubView()
		setConstraint()
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - LifeCycle
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(textField)
		self.addSubview(textFieldTitle)
		self.addSubview(accessoryButton)
	}
	
	private func setConstraint() {
		textField.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview()
			$0.height.equalTo(74)
		}
		
		textFieldTitle.snp.makeConstraints {
			$0.top.equalToSuperview().offset(12)
			$0.leading.equalToSuperview().offset(18)
		}
		
		accessoryButton.snp.makeConstraints {
			$0.height.width.equalTo(48)
			$0.trailing.equalToSuperview().offset(-6)
			$0.bottom.equalToSuperview()
		}
	}
	
	private func bind() {
		
		rxType
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: .def)
			.drive(onNext: { [weak self] colorSet in
				guard let self = self else { return }
				self.configureColorSet(colorSet: colorSet.colorSet)
			})
			.disposed(by: disposeBag)
		
		accessoryButton.rx.tapped
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.accessoryState.accept(!owner.accessoryState.value)
			})
			.disposed(by: disposeBag)
	}
	
	private func configureColorSet(colorSet: TextFieldColorSet) {
		// TODO: 여기서 색깔놀이 하자
		textField.layer.borderColor = colorSet.borderColor.cgColor
		textField.backgroundColor = colorSet.textFieldBackgroundColor
		textField.textColor = colorSet.textFieldTextColor
		accessoryButton.isHidden = accessoryImage == nil
		self.isUserInteractionEnabled = colorSet.isUserInteractive
	}
	
	func makeCustomState(textFieldState: TextFieldType) {
		rxType.accept(textFieldState)
	}
}

extension CMCTextField{
	
	/// TextField의 상태에 따라서
	/// `Boarder color`, `textField background color`, `textField text color`, `isUserInteractive` 를 선택한다.
	/// - Parameters:
	///   - BorderColor : TextField의 border color 색상								// 우선 살리자
	///   - textFieldBackgroundColor : TextField의 background color 색상 // 우선 살리자
	///   - textFieldTextColor : TextField의 text  color 색상						// 우선 살리자
	///   - isUserInteractive : TextField의 isUserInteractive						// 우선 살리자
	
	
	public enum TextFieldType {
		case def /// 초기 상태
		case focus /// 입력 중
		case filed /// 입력 완료
		case disabled /// 불가영역
		case error /// 에러
		
		var colorSet: TextFieldColorSet {
			switch self {
			case .def:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					isUserInteractive: true
				)
			case .focus:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					isUserInteractive: true
				)
			case .filed:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					isUserInteractive: true
				)
			case .disabled:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					isUserInteractive: true
				)
			case .error:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					isUserInteractive: true
				)
			}
		}
	}
	
}


extension CMCTextField: UITextFieldDelegate {
	
	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		self.rxType.accept(.focus)
		return true
	}
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		self.rxType.accept(.focus)
		return true
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return false }
		if text.isEmpty {
			self.rxType.accept(.def)
		} else {
			self.rxType.accept(.filed)
		}
		return true
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return false }
		if text.isEmpty {
			self.rxType.accept(.def)
		} else {
			self.rxType.accept(.filed)
		}
		return true
	}
}


// MARK: - CMCTextField+RxSwift
extension Reactive where Base: CMCTextField {
	
	public func controlEvent(_ events: UIControl.Event) -> ControlEvent<Void> {
		let source = self.base.textField.rx.controlEvent(events).map { _ in }
		return ControlEvent(events: source)
	}
	
	public var text: ControlProperty<String?> {
		return self.base.textField.rx.text
	}
	
}
