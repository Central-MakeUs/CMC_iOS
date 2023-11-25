//
//  ConfirmCertifyCodeBody.swift
//  CMC
//
//  Created by Siri on 11/25/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation

// MARK: - ConfirmCertifyCodeBody
struct ConfirmCertifyCodeBody: Codable {
	let email: String
	let code: String
}
