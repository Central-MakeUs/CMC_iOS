//
//  CMCTouchArea.swift
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

public final class CMCTouchArea: UIView{
	
	public enum TouchAreaStyle: Int {
		case normal = 0
		case selected = 1
	}
	
	// MARK: - UI
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = image[style.value.rawValue]
		return imageView
	}()
	
	// MARK: - Properties
	private var disposeBag = DisposeBag()
	
	private var style = BehaviorRelay<TouchAreaStyle>(value: .normal)
	private var image: [Int:UIImage] = [:]
	
	/// 터치 영역의 `image`를 설정합니다.
	/// - Parameters:
	///  - image: 터치 영역의 `image`
	/// - Parameters (Optional):
	/// - Parameters (Accessable):
	// MARK: - Initializers
	public init(
		image: UIImage? = nil
	) {
		super.init(frame: .zero)
		
		self.setImage(image, for: .normal)
		self.setImage(image, for: .selected)
		
		setAddSubView()
		setConstraint()
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	
	private func setAddSubView() {
		self.addSubview(imageView)
	}
	
	private func setConstraint() {
		imageView.snp.makeConstraints {
			$0.centerX.centerY.equalToSuperview()
		}
	}
	
	private func bind() {
		
		self.style
			.withUnretained(self)
			.subscribe(onNext: { owner, style in
				owner.imageView.image = owner.image[style.rawValue]
			})
			.disposed(by: disposeBag)
		
		self.rx.tapped()
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.style.accept(owner.style.value == .normal ? .selected : .normal)
			})
			.disposed(by: disposeBag)
	}
	
	public func setImage(_ image: UIImage?, for style: TouchAreaStyle) {
		if let image = image {
			self.image.updateValue(image, forKey: style.rawValue)
		}
	}
	
	public func makeCustomState(type: TouchAreaStyle) {
		style.accept(type)
	}
	
}

// MARK: - CMCTouchArea+RxSwift
extension Reactive where Base: UIView {
	public func tapped() -> ControlEvent<Void> {
		let source = self.base.rx.tapGesture().when(.recognized).map { _ in }
		return ControlEvent(events: source)
	}
}
