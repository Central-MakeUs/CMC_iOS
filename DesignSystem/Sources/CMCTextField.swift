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
	
	public enum AccessoryType {
		case image(image: UIImage)
		case button(title: String)
		case none
	}
	
	// MARK: - UI
	fileprivate lazy var textField: CustomTextField = {
		let textField = CustomTextField()
		let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
		textField.leftView = leftPadding
		textField.leftViewMode = .always
		textField.keyboardType = keyboardType
		textField.font = DesignSystemFontFamily.Pretendard.medium.font(size: 15)
		textField.textColor = DesignSystemAsset.gray50.color
		let attributes = [
			NSAttributedString.Key.foregroundColor: DesignSystemAsset.gray700.color,
			NSAttributedString.Key.font: DesignSystemFontFamily.Pretendard.medium.font(size: 15)
		]
		textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: attributes)
		return textField
	}()
	
	private lazy var textFieldTitle: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 14)
		label.textColor = DesignSystemAsset.gray200.color
		label.text = textFieldSubTitle
		return label
	}()
	
	
	/// 우측 악세서리 이미지는, 외부에서 접근 가능해야함.
	public lazy var accessoryButton: CMCTouchArea = {
		let button = CMCTouchArea(image: accessoryImage)
		return button
	}()
	
	/// 우측 악세서리 버튼은, 외부에서 접근 가능해야함.
	public lazy var accessoryCMCButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.disabled),
			title: accessoryTitle
		)
		return button
	}()
	
	private lazy var bottomBoarder: UIView = {
		let view = UIView()
		view.backgroundColor = DesignSystemAsset.gray700.color
		return view
	}()
	
	// MARK: - Properties
	typealias TextFieldColorSet = (
		borderColor: UIColor,
		textFieldBackgroundColor: UIColor,
		textFieldTextColor: UIColor,
		bottomBoarderColor: UIColor,
		isUserInteractive: Bool,
		accessoryHidden: Bool
	)
	
	private var disposeBag = DisposeBag()
	
	private var placeHolder: String
	private var textFieldSubTitle: String
	private var accessoryImage: UIImage = UIImage()
	private var accessoryTitle: String = ""
	private var accessoryType: AccessoryType
	private var keyboardType: UIKeyboardType
	
	public var rxType = BehaviorRelay<TextFieldType>(value: .def)
	public var accessoryState = BehaviorRelay<Bool>(value: false)
	public var isSecureTextEntry: Bool {
		get {
			return textField.isSecureTextEntry
		}
		set {
			textField.isSecureTextEntry = newValue
		}
	}
	
	/// - Parameters:
	///   - placeHolder : placeHolder로 들어갈 텍스트
	///   - accessoryType: 우측 악세서리에 들어가는 타입 (.none 이면 없음)
	///   - textFieldSubTitle: 텍스트필드의 이름을 나타냄
	///   - keyboardType: 키보드 타입
	/// - Parameters (Optional):
	/// - Parameters (Accessable):
	///   - rxType: GalapagosTextField의 타입변환 조종값
	///   - accessoryState: 우측 악세서리 버튼의 상태 (이미지 일 경우만)
	///   - isSecureTextEntry: 텍스트필드의 secureTextEntry 상태
	// MARK: - Initializers
	public init(
		placeHolder: String,
		textFieldSubTitle: String,
		accessoryType: AccessoryType,
		keyboardType: UIKeyboardType
	) {
		self.placeHolder = placeHolder
		self.textFieldSubTitle = textFieldSubTitle
		self.keyboardType = keyboardType
		self.accessoryType = accessoryType
		
		
		switch accessoryType {
		case .button(let title):
			self.accessoryTitle = title
		case .image(let image):
			self.accessoryImage = image
		case .none:
			self.accessoryImage = UIImage()
			self.accessoryTitle = ""
		}
		
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
		self.addSubview(accessoryCMCButton)
		self.addSubview(bottomBoarder)
	}
	
	private func setConstraint() {
		
		
		switch accessoryType {
			
		case .button:
			bottomBoarder.snp.makeConstraints {
				$0.height.equalTo(1)
				$0.leading.bottom.equalToSuperview()
				$0.trailing.equalTo(accessoryCMCButton.snp.leading).offset(-8)
			}
			
			textField.snp.makeConstraints {
				$0.top.leading.equalToSuperview()
				$0.height.equalTo(74)
				$0.trailing.equalTo(accessoryCMCButton.snp.leading).offset(-8)
			}
		default:
			bottomBoarder.snp.makeConstraints {
				$0.height.equalTo(1)
				$0.leading.trailing.bottom.equalToSuperview()
			}
			
			textField.snp.makeConstraints {
				$0.top.leading.trailing.equalToSuperview()
				$0.height.equalTo(74)
			}
		}
		
		
		
		textFieldTitle.snp.makeConstraints {
			$0.top.equalToSuperview().offset(12)
			$0.leading.equalToSuperview().offset(5)
		}
		
		accessoryButton.snp.makeConstraints {
			$0.height.width.equalTo(48)
			$0.trailing.equalToSuperview().offset(-6)
			$0.bottom.equalToSuperview()
		}
		
		accessoryCMCButton.snp.makeConstraints {
			$0.height.equalTo(34)
			$0.width.equalTo(76)
			$0.trailing.equalToSuperview().offset(-18)
			$0.centerY.equalToSuperview()
		}
		
		
	}
	
	private func bind() {
		
		rxType
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: .def)
			.drive(onNext: { [weak self] colorSet in
				guard let self = self else { return }
				self.configureColorSet(colorSet: colorSet.colorSet)
				if rxType.value == .disabled || rxType.value == .def {
					accessoryCMCButton.rxType.accept(.login(.disabled))
				} else {
					accessoryCMCButton.rxType.accept(.login(.inactive))
				}
			})
			.disposed(by: disposeBag)
		
		accessoryButton.rx.tapped()
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.accessoryState.accept(!owner.accessoryState.value)
			})
			.disposed(by: disposeBag)
		
	}
	
	private func configureColorSet(colorSet: TextFieldColorSet) {
		// TODO: 여기서 색깔놀이 하자
		textField.layer.borderColor = UIColor.clear.cgColor
		textField.backgroundColor = .clear
		textField.textColor = colorSet.textFieldTextColor
		bottomBoarder.backgroundColor = colorSet.bottomBoarderColor
		self.isUserInteractionEnabled = colorSet.isUserInteractive
		
		switch accessoryType {
		case .button:
			accessoryButton.removeFromSuperview()
		case .image:
			accessoryCMCButton.removeFromSuperview()
		case .none:
			accessoryButton.removeFromSuperview()
			accessoryCMCButton.removeFromSuperview()
		}
	}
	
	func makeCustomState(textFieldState: TextFieldType) {
		rxType.accept(textFieldState)
	}
}

extension CMCTextField{
	
	/// TextField의 상태에 따라서
	/// `Boarder color`, `textField background color`, `textField text color`, `isUserInteractive`,  `accessoryHidden`를 선택한다.
	/// - Parameters:
	///   - BorderColor : TextField의 border color 색상								// 우선 살리자
	///   - textFieldBackgroundColor : TextField의 background color 색상 // 우선 살리자
	///   - textFieldTextColor : TextField의 text  color 색상						// 우선 살리자
	///   - isUserInteractive : TextField의 isUserInteractive						// 우선 살리자
	///   - accessoryHidden : 우측 악세서리의 hidden 상태 처리						// 우선 살리자
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
					bottomBoarderColor: DesignSystemAsset.gray700.color,
					isUserInteractive: true,
					accessoryHidden: true
				)
			case .focus:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray100.color,
					isUserInteractive: true,
					accessoryHidden: false
				)
			case .filed:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray100.color,
					isUserInteractive: true,
					accessoryHidden: false
				)
			case .disabled:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray700.color,
					isUserInteractive: false,
					accessoryHidden: false
				)
			case .error:
				return TextFieldColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.error.color,
					isUserInteractive: true,
					accessoryHidden: false
				)
			}
		}
	}
	
}

class CustomTextField: UITextField {
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(
			x: bounds.origin.x + 5,
			y: bounds.origin.y + 15,
			width: bounds.width,
			height: bounds.height
		)
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(
			x: bounds.origin.x + 5,
			y: bounds.origin.y + 15,
			width: bounds.width,
			height: bounds.height
		)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(
			x: bounds.origin.x + 5,
			y: bounds.origin.y + 15,
			width: bounds.width,
			height: bounds.height
		)
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
