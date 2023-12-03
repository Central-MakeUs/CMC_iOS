//
//  UILabel+.swift
//  CMC
//
//  Created by Siri on 12/3/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import UIKit

extension UIColor {
		convenience init(hex: UInt, alpha: CGFloat = 1.0) {
				self.init(
						red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
						green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
						blue: CGFloat(hex & 0x0000FF) / 255.0,
						alpha: CGFloat(alpha)
				)
		}
}
