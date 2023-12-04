//
//  AuthUsecase.swift
//  CMC
//
//  Created by Siri on 10/27/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthUsecase {
	func signUp(body: SignUpBody) -> Single<SignUpModel>
	func signIn(body: SignInBody) -> Single<SignInModel>
	func emailDup(query: EmailDupQuery) -> Single<EmailDupModel>
	func sendCertifyCode(query: SendCertifyCodeQuery) -> Single<SendCertifyCodeModel>
	func confirmCertifyCode(body: ConfirmCertifyCodeBody) -> Single<ConfirmCertifyCodeModel>
	func reSettingPassword(body: ResettingPasswordBody) -> Single<ResettingPasswordModel>
	func refresh() -> Single<RefreshModel>
}
