//
//  CMCTextField+Timer.swift
//  DesignSystem
//
//  Created by Siri on 11/15/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import SnapKit

import UIKit

public final class CMCTextField_Timer: UIView {
	
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
		label.textColor = DesignSystemAsset.gray500.color
		label.text = textFieldSubTitle
		return label
	}()
	
	public lazy var accessoryCMCButton: CMCButton = {
		let button = CMCButton(
			isRound: false,
			iconTitle: nil,
			type: .login(.inactive),
			title: buttonTitle
		)
		return button
	}()
	
	private lazy var bottomBoarder: UIView = {
		let view = UIView()
		view.backgroundColor = DesignSystemAsset.gray700.color
		return view
	}()
	
	private lazy var timerLabel: UILabel = {
		let label = UILabel()
		label.textColor = DesignSystemAsset.error.color
		label.font = DesignSystemFontFamily.Pretendard.medium.font(size: 13)
		return label
	}()
	
	// MARK: - Properties
	
	typealias TextField_TimerColorSet = (
		borderColor: UIColor,
		textFieldBackgroundColor: UIColor,
		textFieldTextColor: UIColor,
		bottomBoarderColor: UIColor,
		isUserInteractive: Bool
	)
	
	private var disposeBag = DisposeBag()
	private var timerDisposeBag = DisposeBag()
	
	private var placeHolder: String
	private var textFieldSubTitle: String
	private var buttonTitle: String
	private var keyboardType: UIKeyboardType
	
	private var timerCountRelay = BehaviorRelay<Int>(value: 180)
	public var rxType = BehaviorRelay<TextFieldWithTimerType>(value: .def)
	public var resetTimerSubject = PublishSubject<Void>()
	
	/// - Parameters:
	///   - placeHolder : placeHolder로 들어갈 텍스트
	///   - textFieldSubTitle: 텍스트필드의 이름을 나타냄
	///   - buttonTitle: 우측 버튼의 이름
	///   - keyboardType: 키보드 타입
	/// - Parameters (Optional):
	/// - Parameters (Accessable):
	///   - rxType: CMCTextField_Timer의 타입변환 조종값
	// MARK: - Initializers
	public init(
		placeHolder: String,
		textFieldSubTitle: String,
		buttonTitle: String,
		keyboardType: UIKeyboardType
	) {
		self.placeHolder = placeHolder
		self.textFieldSubTitle = textFieldSubTitle
		self.buttonTitle = buttonTitle
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
		self.addSubview(accessoryCMCButton)
		self.addSubview(bottomBoarder)
		self.addSubview(timerLabel)
	}
	
	private func setConstraint() {
		
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
		
		textFieldTitle.snp.makeConstraints {
			$0.top.equalToSuperview().offset(12)
			$0.leading.equalToSuperview().offset(5)
		}
		
		accessoryCMCButton.snp.makeConstraints {
			$0.height.equalTo(34)
			$0.width.equalTo(76)
			$0.trailing.equalToSuperview().offset(-18)
			$0.top.equalToSuperview().offset(26)
		}
		
		timerLabel.snp.makeConstraints {
			$0.centerY.equalTo(accessoryCMCButton)
			$0.trailing.equalTo(accessoryCMCButton.snp.leading).offset(-16)
			$0.height.equalTo(18)
		}
		
	}
	
	private func bind() {
		
		resetTimerSubject
			.subscribe(onNext: { [weak self] in
				guard let self = self else { return }
				self.resetTimer()
			})
			.disposed(by: disposeBag)
		
		rxType
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: .def)
			.drive(onNext: { [weak self] type in
				guard let self = self else { return }
				self.configureColorSet(colorSet: type.colorSet)
			})
			.disposed(by: disposeBag)
		
	}
	
	private func configureColorSet(colorSet: TextField_TimerColorSet) {
		// TODO: 여기서 색깔놀이 하자
		textField.layer.borderColor = UIColor.clear.cgColor
		textField.backgroundColor = .clear
		textField.textColor = colorSet.textFieldTextColor
		bottomBoarder.backgroundColor = colorSet.bottomBoarderColor
		self.isUserInteractionEnabled = colorSet.isUserInteractive
	}
	
	func makeCustomState(textFieldWithTimerState: TextFieldWithTimerType) {
		rxType.accept(textFieldWithTimerState)
	}
	
	private func startTimer() {
		timerDisposeBag = DisposeBag() // 이전 타이머 구독 해제
		
		Observable<Int>
			.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
			.withLatestFrom(timerCountRelay.asObservable()) { _, count in count }
			.map { $0 - 1 }
			.do(onNext: { [weak self] newCount in
				self?.timerCountRelay.accept(newCount)
			})
			.take(while: {  $0 >= 0 })
			.map { timeInSeconds -> String in
				let minutes = timeInSeconds / 60
				let seconds = timeInSeconds % 60
				return String(format: "%02d:%02d", minutes, seconds)
			}
			.asDriver(onErrorJustReturn: "Error")
			.drive(timerLabel.rx.text)
			.disposed(by: timerDisposeBag)
	}
	
	public func resetTimer() {
		timerCountRelay.accept(180)  // 초기 시간을 180초로 설정
		startTimer()                 // 타이머 다시 시작
	}
	
	public func controlTimer(isOn: Bool) {
		if isOn {
			startTimer()
		} else {
			timerDisposeBag = DisposeBag() // 타이머 구독 해제
		}
	}
	
	
}


extension CMCTextField_Timer{
	
	/// TextField의 상태에 따라서
	/// `Boarder color`, `textField background color`, `textField text color`,
	/// `errorMessage Hidden`, `isUserInteractive` 를 선택한다.
	/// - Parameters:
	///   - BorderColor : TextField의 border color 색상
	///   - textFieldBackgroundColor : TextField의 background color 색상
	///   - textFieldTextColor : TextField의 text  color 색상
	///   - isUserInteractive : TextField의 isUserInteractive
	
	
	public enum TextFieldWithTimerType {
		case def /// 초기 상태
		case focus /// 입력 중
		case filed /// 입력 완료
		case disabled /// 불가영역
		case error /// 에러
		
		var colorSet: TextField_TimerColorSet {
			switch self {
			case .def:
				return TextField_TimerColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray700.color,
					isUserInteractive: true
				)
			case .focus:
				return TextField_TimerColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray100.color,
					isUserInteractive: true
				)
			case .filed:
				return TextField_TimerColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray100.color,
					isUserInteractive: true
				)
			case .disabled:
				return TextField_TimerColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.gray700.color,
					isUserInteractive: false
				)
			case .error:
				return TextField_TimerColorSet(
					borderColor: DesignSystemAsset.gray800.color,
					textFieldBackgroundColor: DesignSystemAsset.gray800.color,
					textFieldTextColor: DesignSystemAsset.gray50.color,
					bottomBoarderColor: DesignSystemAsset.error.color,
					isUserInteractive: true
				)
				
			}
		}
	}
	
}


extension CMCTextField_Timer: UITextFieldDelegate {
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		self.rxType.accept(.focus)
		return true
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		self.rxType.accept(.filed)
		return true
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.rxType.accept(.filed)
		return true
	}
}


// MARK: - CMCTextField_Timer+RxSwift
extension Reactive where Base: CMCTextField_Timer {
	
	public func controlEvent(_ events: UIControl.Event) -> ControlEvent<Void> {
		let source = self.base.textField.rx.controlEvent(events).map { _ in }
		return ControlEvent(events: source)
	}
	
	public var text: ControlProperty<String?> {
		return self.base.textField.rx.text
	}
	
	public var becomeFirstResponder: Binder<Void> {
		return Binder(self.base) { textField, _ in
			textField.textField.becomeFirstResponder()
		}
	}
	
	public var confirmBtnTapped: ControlEvent<Void> {
		return self.base.accessoryCMCButton.rx.tap
	}
}
