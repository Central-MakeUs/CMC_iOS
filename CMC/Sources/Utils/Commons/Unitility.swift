//
//  Unitility.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

class Utility {
	
	/// - `data`를 `T` 타입으로 디코딩하자~
	static func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
		do {
			let decodedObject = try JSONDecoder().decode(T.self, from: data)
			return decodedObject
		} catch {
			print("Failed to decode \(T.self) from data: \(error)")
			return nil
		}
	}
	
	static func decodeError(from data: Data) -> ServerError {
		do {
			let decodedObject = try JSONDecoder().decode(ServerError.self, from: data)
			return decodedObject
		} catch {
			return ServerError(
				isSuccess: false,
				code: "USER9999",
				message: "Failed to decode ServerError from data: \(error)"
			)
		}
	}
	
	static func checkEmailValidation(email: Observable<String>, validate: EmailValidate) -> Observable<Bool> {
		let emailTest = NSPredicate(format: "SELF MATCHES %@", validate.validate)
		return email.map { email in
			return emailTest.evaluate(with: email)
		}
	}
	
	static func checkPasswordValidation(password: Observable<String>, validate: PasswordValidate) -> Observable<Bool> {
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", validate.validate)
		return password.map { password in
			return passwordTest.evaluate(with: password)
		}
	}
	
	static func checkNicknameValidation(nickname: Observable<String>, validate: NicknameValidate) -> Observable<Bool> {
		let nicknameTest = NSPredicate(format: "SELF MATCHES %@", validate.validate)
		return nickname.map { nickname in
			return nicknameTest.evaluate(with: nickname)
		}
	}
	
}
