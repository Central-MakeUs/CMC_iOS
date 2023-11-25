//
//  DefaultAuthUsecase.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAuthUsecase: AuthUsecase {
	
	private let authRepository: AuthRepository
	
	init(authRepository: AuthRepository) {
		self.authRepository = authRepository
	}
	
	func signUp(body: SignUpBody) -> Single<SignUpModel> {
		return authRepository.signUp(body: body)
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func signIn(body: SignInBody) -> Single<SignInModel> {
		return authRepository.signIn(body: body)
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func emailDup(query: EmailDupQuery) -> Single<EmailDupModel> {
		return authRepository.emailDup(query: query)
			.map { dto in
				return dto.toDomain()
			}
	}
	
	func sendCertifyCode(query: SendCertifyCodeQuery) -> Single<SendCertifyCodeModel> {
		return authRepository.sendCertifyCode(query: query)
			.map { dto in
				return dto.toDomain()
			}
	}
}
