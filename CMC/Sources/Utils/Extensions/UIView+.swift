//
//  UIView+.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture


extension Reactive where Base: UIView {
	public func tapped() -> ControlEvent<Void> {
		let source = self.base.rx.tapGesture().when(.recognized).map { _ in }
		return ControlEvent(events: source)
	}
}
