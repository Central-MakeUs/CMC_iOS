//
//  SignUpBody.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

// MARK: - SignUpBody
struct SignUpBody: Codable {
	let email: String
	let password: String
	let nickname: String
	let name: String
	let generation: Int
	let part: String
	
}

enum Part: String, Codable {
	case none = "포지션을 선택해주세요"
	case BACK_END = "Server"
	case WEB = "Web"
	case IOS = "iOS"
	case AOS = "Android"
	case PLANNER = "Planner"
	case DESIGNER = "Designer"
	
	func revertPart() -> String {
		switch self {
		case .BACK_END:
			return "BACK_END"
		case .WEB:
			return "WEB"
		case .IOS:
			return "IOS"
		case .AOS:
			return "AOS"
		case .PLANNER:
			return "PLANNER"
		case .DESIGNER:
			return "DESIGNER"
		case .none:
			return "none"
		}
	}
	
}
