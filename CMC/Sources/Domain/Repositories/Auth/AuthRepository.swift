//
//  AuthRepository.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthRepository {
	func signUp(body: SignUpBody) -> Single<SignUpDTO>
	func signIn(body: SignInBody) -> Single<SignInDTO>
	func emailDup(query: EmailDupQuery) -> Single<EmailDupDTO>
	func sendCertifyCode(query: SendCertifyCodeQuery) -> Single<SendCertifyCodeDTO>
	func confirmCertifyCode(body: ConfirmCertifyCodeBody) -> Single<ConfirmCertifyCodeDTO>
	func reSettingPassword(body: ResettingPasswordBody) -> Single<ResettingPasswordDTO>
	func refresh() -> Single<RefreshDTO>
}
