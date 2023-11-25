//
//  DefaultAuthRepository.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAuthRepository: AuthRepository {
	
	private let networkService: NetworkService
	
	init() {
		self.networkService = DefaultNetworkService()
	}
	
	func signUp(body: SignUpBody) -> Single<SignUpDTO> {
		let endpoint = AuthEndpoint.signUp(body: body)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(SignUpDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func signIn(body: SignInBody) -> Single<SignInDTO> {
		let endpoint = AuthEndpoint.signIn(body: body)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(SignInDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func emailDup(query: EmailDupQuery) -> Single<EmailDupDTO> {
		let endpoint = AuthEndpoint.emailDup(query: query)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(EmailDupDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func sendCertifyCode(query: SendCertifyCodeQuery) -> Single<SendCertifyCodeDTO> {
		let endpoint = AuthEndpoint.sendCertifyCode(query: query)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(SendCertifyCodeDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func confirmCertifyCode(body: ConfirmCertifyCodeBody) -> Single<ConfirmCertifyCodeDTO> {
		let endpoint = AuthEndpoint.confirmCertifyCode(body: body)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(ConfirmCertifyCodeDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	func reSettingPassword(body: ResettingPasswordBody) -> Single<ResettingPasswordDTO> {
		let endpoint = AuthEndpoint.resettingPassword(body: body)
		return networkService.request(endpoint)
			.flatMap { data in
				guard let dto = Utility.decode(ResettingPasswordDTO.self, from: data) else {
					return Single.error(NetworkError.decodingFailed)
				}
				return Single.just(dto)
			}
	}
	
	
}
