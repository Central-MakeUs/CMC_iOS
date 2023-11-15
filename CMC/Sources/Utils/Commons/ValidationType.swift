//
//  ValidationType.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

enum EmailValidate {
	
	case emailRegex
	
	var validate: String {
		switch self {
		case .emailRegex:
			return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		}
	}
}

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
			return "^.{8,16}$"
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
