//
//  ValidationType.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum PasswordValidate {
	
	case englishRegex
	case numberRegex
	case specialCharRegex
	case lengthRegex
	
	var validate: String {
		switch self {
		case .englishRegex:
			return ".*[A-Za-z]+.*"
		case .numberRegex:
			return ".*[0-9]+.*"
		case .specialCharRegex:
			return ".*[!@#$%^&*()_+{}:<>?]+.*"
		case .lengthRegex:
			return "^.{8,20}$"
		}
	}
}

enum NicknameValidate {
	case lengthRegex
	
	var validate: String {
		switch self {
		case .lengthRegex:
			return "^.{2,6}$"
		}
	}
}