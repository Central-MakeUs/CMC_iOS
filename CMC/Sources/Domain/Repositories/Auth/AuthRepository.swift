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
}
