//
//  UserUsecase.swift
//  CMC
//
//  Created by Siri on 12/4/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import RxSwift

protocol UserUsecase {
	func getUser() -> Single<GetUserModel>
	func deleteUser() -> Single<DeleteUserModel>
}
