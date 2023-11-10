//
//  FakeAuthRepository.swift
//  CMC
//
//  Created by Siri on 11/7/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

final class FakeAuthRepository: AuthRepository {
	
	func signUp(body: SignUpBody) -> Single<SignUpDTO> {
		let fakeSignUpDTO = SignUpDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: .init(
				userId: 14,
				accessToken: "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMzODQifQ.eyJ1c2VySWQiOjEsImlhdCI6MTY5OTM1NTk2MiwiZXhwIjozMzIzNTM1NTk2Mn0.Ss8FNWSD1kVbETnFD4C6d9jQYt2c_vdhUwRL84uQA1aW06csWw6Je7bcge22KY_B",
				refreshToken: "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMzODQifQ.eyJ1c2VySWQiOjEsImlhdCI6MTY5OTM1NTk2MiwiZXhwIjozMzIzNTM1NTk2Mn0.Ss8FNWSD1kVbETnFD4C6d9jQYt2c_vdhUwRL84uQA1aW06csWw6Je7bcge22KY_B"
			)
		)
		return Single.just(fakeSignUpDTO)
	}
	
	func signIn(body: SignInBody) -> Single<SignInDTO> {
		let fakeSignInDTO = SignInDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: .init(
				userId: 14,
				accessToken: "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMzODQifQ.eyJ1c2VySWQiOjEsImlhdCI6MTY5OTM1NTk2MiwiZXhwIjozMzIzNTM1NTk2Mn0.Ss8FNWSD1kVbETnFD4C6d9jQYt2c_vdhUwRL84uQA1aW06csWw6Je7bcge22KY_B",
				refreshToken: "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMzODQifQ.eyJ1c2VySWQiOjEsImlhdCI6MTY5OTM1NTk2MiwiZXhwIjozMzIzNTM1NTk2Mn0.Ss8FNWSD1kVbETnFD4C6d9jQYt2c_vdhUwRL84uQA1aW06csWw6Je7bcge22KY_B"
			)
		)
		return Single.just(fakeSignInDTO)
	}
	
	func emailDup(query: EmailDupQuery) -> Single<EmailDupDTO> {
		let fakeEmailDupDTO = EmailDupDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: .init(message: "이메일 인증에 성공했어요~!")
		)
		return Single.just(fakeEmailDupDTO)
	}
	
}
