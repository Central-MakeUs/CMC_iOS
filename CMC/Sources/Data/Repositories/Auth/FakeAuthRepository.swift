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
			result: "사용 가능한 이메일입니다."
		)
		return Single.just(fakeEmailDupDTO)
	}
		
	func sendCertifyCode(query: SendCertifyCodeQuery) -> Single<SendCertifyCodeDTO> {
		let fakeSendCertifyCodeDTO = SendCertifyCodeDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: "인증번호가 발송되었습니다."
		)
		return Single.just(fakeSendCertifyCodeDTO)
	}
	
	func confirmCertifyCode(body: ConfirmCertifyCodeBody) -> Single<ConfirmCertifyCodeDTO> {
		let fakeConfirmCertifyCodeDTO = ConfirmCertifyCodeDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: "인증번호가 발송되었습니다."
		)
		return Single.just(fakeConfirmCertifyCodeDTO)
	}
	
	func reSettingPassword(body: ResettingPasswordBody) -> Single<ResettingPasswordDTO> {
		let fakeResettingPasswordDTO = ResettingPasswordDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: "인증번호가 발송되었습니다."
		)
		return Single.just(fakeResettingPasswordDTO)
	}
	
	func refresh() -> Single<RefreshDTO> {
		let fakeRefreshDTO = RefreshDTO(
			isSuccess: true,
			code: "200",
			message: "성공",
			result: .init(
				accessToken: "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMzODQifQ.eyJ1c2VySWQiOjEsImlhdCI6MTY5OTM1NTk2MiwiZXhwIjozMzIzNTM1NTk2Mn0.Ss8FNWSD1kVbETnFD4C6d9jQYt2c_vdhUwRL84uQA1aW06csWw6Je7bcge22KY_B"
			)
		)
		return Single.just(fakeRefreshDTO)
	}
}
