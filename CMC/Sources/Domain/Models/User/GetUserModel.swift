//
//  GetUserModel.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//


//MARK: - GetUserModel
struct GetUserModel: Codable {
	let name: String
	let email: String
	let nickname: String
	let generation: Int
	let part: String
}

enum PartModel: String, Codable {
	case BACK_END = "BACK_END"
	case WEB = "WEB"
	case IOS = "IOS"
	case AOS = "AOS"
	case PLANNER = "PLANNER"
	case DESIGNER = "DESIGNER"
	
	func revertPart() -> String {
		switch self {
		case .BACK_END:
			return "Server"
		case .WEB:
			return "Web"
		case .IOS:
			return "iOS"
		case .AOS:
			return "Android"
		case .PLANNER:
			return "Planner"
		case .DESIGNER:
			return "Designer"
		}
	}
}
